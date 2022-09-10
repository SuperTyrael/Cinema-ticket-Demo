const express = require('express');
const nJwt = require("njwt");
const router = express.Router();


/* GET home page. */
router.post('/', function (req, res, next) {
    let token = req.body.token
    nJwt.verify(token, req.app.get('signingKey'), function (err, verifiedJwt) {
        if (err) {
            res.send("err")
        } else {
            let username = verifiedJwt.body.sub
            res.render('index', {title: 'ticket system homepage', user: username});
        }
    });
});


module.exports = router;
