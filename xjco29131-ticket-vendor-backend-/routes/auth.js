const express = require('express');
const router = express.Router();
const nJwt = require('njwt');
const sqlite3 = require("sqlite3");
const utility = require("utility");
const uuid = require('node-uuid');
const db = new sqlite3.Database('./db/movie.db');
const log4js = require("log4js");
const logger = log4js.getLogger();

const model = require('../model/model')

logger.level = "info";

Date.prototype.Format = function (fmt) {
    const o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (const k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}


function verify(username, pw) {
    return new Promise(function (resolve) {
        model.get_user_info(username).then((user_info)=>{
            if(user_info.status === 1){
                if(user_info.data.user_info !== undefined){
                    model.get_salt(user_info.data.user_info.uid).then((salt_value)=>{
                        if(salt_value.status === 1){
                            if(salt_value.data.salt !== undefined){
                                resolve(username === user_info.data.user_info.username &&
                                    utility.md5(pw + salt_value.data.salt['s_value']))
                            }else {
                                resolve(false)
                            }
                        }else {
                            resolve(false)
                        }
                    })
                }else {
                    resolve(false)
                }
            }else {
                resolve(false)
            }
        })
    });
}


function encryption(pw, req, uid, state) {
    function ip(req) {
        let ipAddress;
        const forwardedIpsStr = req.headers['X-Forwarded-For'];
        if (forwardedIpsStr) {
            const forwardedIps = forwardedIpsStr.split(',');
            ipAddress = forwardedIps[0];
        }
        if (!ipAddress) {
            ipAddress = req.connection.remoteAddress;
        }
        return ipAddress;
    }

    let word = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    let rand_word = ''
    for (let i = 0; i < 36; i++) {
        rand_word += word[Math.round(Math.random() * 35)];
    }
    let rand_num = Math.round(Math.random() * 100000000);
    let date = new Date();
    let ipk = ip(req).substring(7);
    let cuid = uuid.v1()
    let salt = utility.md5(uid + ipk + date + 'elpsycongroo' + cuid + rand_num + rand_word);
    if (state === 0) {
        db.run('INSERT INTO salt (uid,s_value) VALUES($uid,$salt)', {
            $uid: uid,
            $salt: salt
        });
    } else {
        db.run('UPDATE salt SET uid=$name,s_value=$salt WHERE uid=$uid', {
            $uid: uid,
            $salt: salt,
        })
    }
    return utility.md5(pw + salt);
}


/* GET auth. */
router.post('/register', function (req, res) {
        let username = req.body.username;
        let pw = req.body.password;
        let email = req.body.email;
        let phone = req.body.phone;
        const claims = {
            iss: "http://film_ticket/",
            sub: username,
        };
        const jwt = nJwt.create(claims, req.app.get('signingKey'));
        const token = jwt.compact();


        model.get_user_info(username).then((user_info)=>{
            if(user_info.status === 1){
                if(user_info.data.user_info === undefined){
                    model.register_user(username, pw, email, phone).then((register_info)=>{
                        if(register_info.status === 1){
                            model.get_uid(username).then((uid_info)=>{
                                if(uid_info.status === 1){
                                    if(uid_info.data.uid !== undefined){
                                        model.update_pw(username, encryption(pw, req, uid_info.data.uid['uid'], 0)).then((update_info)=>{
                                            logger.info("register successful: "+ username);
                                            update_info['data']['token'] = token
                                            res.send(update_info)
                                        })
                                    }else {
                                        res.send({status: 2, data: {'info': 'uid cannot found'}});
                                    }
                                }else {
                                    res.send(uid_info);
                                }
                            })
                        }else {
                            res.send(register_info)
                        }
                    })
                }else {
                    res.send({status: 2, data: {'info': 'user already existed'}});
                }
            }else {
                res.send(user_info)
            }
        })
    }
);

router.post('/login', function (req, res) {
        let username = req.body.username;
        let pw = req.body.password;
        const claims = {
            iss: "http://film_ticket/",
            sub: username,
        };
        const jwt = nJwt.create(claims, req.app.get('signingKey'));
        const token = jwt.compact();

        verify(username, pw).then(function (response) {
            if (response) {
                logger.info("login successful: "+ username);
                logger.info("token: "+ token);
                res.send({status: 1, data: {'token': token, 'info': 'successful'}});
            } else {
                res.send({status: 0, data: {'info': 'verify err'}});
            }
        });
    }
);

module.exports = router;
