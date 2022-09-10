const express = require('express');
const router = express.Router();

const model = require('../model/model_admin')

/* GET admin listing. */
router.get('/', function (req, res, next) {
    res.send('respond with a resource');
});


router.get('/users_info', function (req, res, next) {
    model.get_user_info().then((users_info)=>{
        res.send(users_info)
    })
})


router.post('/insert_film', function (req, res, next) {
    let film_info = {
        "film_name": req.body['film_name'], "director": req.body['director'], "starring": req.body['starring']
        , "blurb": req.body['blurb'], "classification": req.body['classification'], "rank": req.body['rank']
        , "release_time": req.body['release_time'], "running_time": req.body['running_time']
        , "is_released": req.body['is_released'], "bbfc": req.body['bbfc']
    }

    model.insert_film(film_info).then((insert_info)=>{
        res.send(insert_info)
    })
});

router.post('/update_film', function (req, res, next) {
    let film_info = {
        "film_id":req.body['film_id'], "film_name": req.body['film_name'], "director": req.body['director'], "starring": req.body['starring']
        , "blurb": req.body['blurb'], "classification": req.body['classification'], "rank": req.body['rank']
        , "release_time": req.body['release_time'], "running_time": req.body['running_time']
        , "is_released": req.body['is_released']
    }

    model.update_film(film_info).then((update_info)=>{
        res.send(update_info)
    })
});

router.post('/delete_film', function (req, res, next) {
    let film_id = req.body['film_id']
    model.delete_film(film_id).then((delete_info)=>{
        res.send(delete_info)
    })
})

router.post('/search_film', function (req, res, next) {
    let film_name = req.body['film_name']
    model.search_film(film_name).then((search_info)=>{
        res.send(search_info)
    })
})

module.exports = router;
