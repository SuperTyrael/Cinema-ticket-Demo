const express = require('express');
const router = express.Router();
const log4js = require("log4js");
const logger = log4js.getLogger();
const model = require('../model/model')

logger.level = "info";


router.get('/cinemas_info', function (req, res) {
    logger.info("query cinemas info successful");
    model.get_cinemas_info().then((cinemas_info)=>{
        res.send(cinemas_info)
    })
});


router.post('/venues_info', function (req, res) {
    let cinema_id = req.body['cinema']
    if (cinema_id != null) {
        logger.info("query venues info successful");
        model.get_venues_info(cinema_id).then((venues_info)=>{
            res.send(venues_info)
        })
    } else {
        res.send({status: 0, data: {'info': 'cinema id cannot be null'}});
    }
});


router.get('/films_info', function (req, res) {
    logger.info("query film info successful");
    model.get_films_info().then((films_info)=>{
        res.send(films_info)
    })
});


router.post('/film_class_info', function (req, res) {
    let fid = req.body['fid']
    logger.info("query film classification info successful");
    model.get_film_classification(fid).then((films_class_info)=>{
        res.send(films_class_info)
    })
});


router.post('/seats_map_info', function (req, res) {
    let venue_id = req.body['venue_id']
    if (venue_id != null) {
        logger.info("query seats info successful");
        model.get_seats_map_info(venue_id).then((seats_info)=>{
            res.send(seats_info)
        })
    } else {
        res.send({status: 0, data: {'info': 'venue id cannot be null'}});
    }
});


router.post('/booked_map_info', function (req, res) {
    let screening_id = req.body['screening_id']
    if (screening_id != null) {
        logger.info("query booked seats info successful");
        model.get_booked_map_info(screening_id).then((seats_info)=>{
            res.send(seats_info)
        })
    } else {
        res.send({status: 0, data: {'info': 'screening id cannot be null'}});
    }
});


router.post('/cinema_film', function (req, res) {
    let film_id = req.body['film_id']
    if (film_id != null) {
        logger.info("query screenings info successful");
        model.get_cinema_film(film_id).then((cinemas_info)=>{
            res.send(cinemas_info)
        })
    } else {
        res.send({status: 0, data: {'info': 'film id cannot be null'}});
    }
});


router.post('/screenings_film', function (req, res) {
    let cinema_id = req.body['cinema_id'];
    let fid = req.body['film_id'];
    if (cinema_id != null) {
        logger.info("query screenings info successful");
        model.get_screenings_film(cinema_id, fid).then((screenings_info)=>{
            res.send(screenings_info)
        })
    } else {
        res.send({status: 0, data: {'info': 'cinema id cannot be null'}});
    }
});


router.post('/screenings_info', function (req, res) {
    let cinema_id = req.body['cinema_id'];
    if (cinema_id != null) {
        logger.info("query screenings info successful");
        model.get_screenings_info(cinema_id).then((screenings_info)=>{
            res.send(screenings_info)
        })
    } else {
        res.send({status: 0, data: {'info': 'cinema id cannot be null'}});
    }
});


module.exports = router;
