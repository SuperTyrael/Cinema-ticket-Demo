const express = require('express');
const router = express.Router();
const nJwt = require("njwt");
const log4js = require("log4js");
const logger = log4js.getLogger();
const random = require('string-random')

const model = require('../model/model')

logger.level = "info";

let forgetting_curve = function (t){
    let k0 = 1
    let k1 = 160
    let k2 = 50
    let b = 10
    return k0 * Math.exp((k1 - t) / k2) + b
}

let update_recommend = function (user){
    model.get_user_action(user).then((user_actions)=>{
        let current_time = new Date().Format("yyyy-MM-dd");
        for(let action of user_actions){
            action.val = action.val * (forgetting_curve(to_time(action['create_time'])) - forgetting_curve(to_time(current_time)))
        }
    })
}

let get_action = function (action, user){
    model.get_user_recommend(user).then((recommend_info=>{
        let update_var = 6
        let add_class_weight_map = {}
        for(let action_class of action){
            add_class_weight_map[action_class.class] = action_class['action_val']
        }
        add_class_weight_map = absolute_weight(sum_zero(add_class_weight_map), update_var)
        update_recommend(recommend_info, add_class_weight_map)
    }))
}

router.use(function (req, res, next){
    let token = req.query.token
    nJwt.verify(token, req.app.get('signingKey'), function (err, verifiedJwt) {
        if (err) {
            res.send({status: 0, data: {'info': err}});
        } else {
            res.locals.username = verifiedJwt.body.sub;
            next()
        }
    });
})


/* GET users listing. */
router.get('/', function (req, res, next) {
    res.send('test');
});

router.get('/user_info', function (req, res, next) {
    let username = res.locals.username;
    model.get_user_info(username).then((user_info)=>{
        res.send(user_info);
    })
})


router.post('/user_click', function (req, res){
    let username = res.locals.username;
    let film_id = req.body['film_id']
    model.get_uid(username).then((uid_info)=>{
        let uid = uid_info.data['uid']['uid'];
        model.user_action(uid, film_id, 1).then((click_info)=>{
            res.send(click_info)
        })
    })
})


router.get('/user_recommend', function (req, res){
    let username = res.locals.username;
    logger.info("query recommend list successful: "+ username);
    res.send({status: 0, data: {'info': 'err'}});
})


router.post('/booking', function (req, res) {
    let username = res.locals.username;
    let screening_id = req.body['screening_id'];
    let seat_id = req.body['seat_id'];
    let user_type = req.body['user_type'];

    model.get_uid(username).then((uid_info)=>{
        if(uid_info.status === 1){
            let uid = uid_info.data['uid']['uid'];
            if (uid != null && screening_id != null && seat_id != null && user_type != null) {
                model.verify_booking(uid, screening_id, seat_id).then((is_valid)=>{
                    if (is_valid) {
                        model.get_booking_info(screening_id, seat_id).then((booking_info)=>{
                            if(booking_info.status === 1){
                                let booking_data = booking_info.data['booking']
                                if(booking_data == null){
                                    let rand_str = random(32);
                                    model.create_booking(uid, screening_id, seat_id, user_type, rand_str).then((secret_info)=>{
                                        model.get_film_id_from_screening(screening_id).then((film_info)=>{
                                            model.user_action(uid, film_info['data']['film_id']['film_id'], 2).then((click_info)=>{
                                            })
                                        })
                                        res.send(secret_info)
                                    })
                                }else {
                                    res.send({status: 0, data: {'info': 'seat already booked'}});
                                }
                            }else {
                                res.send({status: 0, data: {'info': booking_info}});
                            }
                        })
                    }else {
                        res.send({status: 0, data: {'info': 'invalid booking'}});
                    }
                })
            }
        }else {
            res.send({status: 0, data: {'info': uid_info}});
        }
    })
});

module.exports = router;
