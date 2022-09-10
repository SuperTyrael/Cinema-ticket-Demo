const sqlite3 = require("sqlite3");
const db = new sqlite3.Database('./db/movie.db');

function get_user_info(username){
    return new Promise(function (resolve) {
        db.get('SELECT uid, username, email, mobile, created_at FROM user WHERE username=$username', {'$username': username}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'user_info': rows, 'info': 'successful'}})
            }
        })
    })
}


function get_salt(uid){
    return new Promise(function (resolve){
        db.get('SELECT s_value FROM salt WHERE uid=$uid', {
            $uid: uid
        }, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'salt': rows, 'info': 'successful'}})
            }
        })
    })
}


function register_user(username, pw, email, phone){
    return new Promise(function (resolve){
        let current_time = new Date().Format("yyyy-MM-dd");
        db.run("INSERT INTO user(username, pw, email, mobile, created_at) VALUES ($username, $pw, $email, $mobile, $created_at)", {
            $username: username,
            $pw: '',
            $mobile: phone,
            $email: email,
            $created_at: current_time
        }, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'info': 'successful'}})
            }
        })
    })
}


function update_pw(username, pw){
    return new Promise(function (resolve){
        db.run("UPDATE user SET pw=$pw WHERE username=$username", {
            $username: username,
            $pw: pw
        }, function (err, rows){
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'info': 'successful'}})
            }
        })
    })
}


function get_uid(username){
    return new Promise(function (resolve) {
        db.get("SELECT uid FROM user WHERE username=$username", {$username: username}, function (err, rows){
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'uid': rows, 'info': 'successful'}})
            }
        })
    })
}


function verify_booking(uid, screening_id, seat_id) {
    return new Promise(function (resolve) {
        db.get("SELECT * FROM user WHERE uid=$uid", {$uid: uid}, function (err, rows) {
            if (err) {
                resolve(false);
            } else {
                db.get("SELECT * FROM screening WHERE sid=$sid", {$sid: screening_id}, function (err, rows) {
                    if (err) {
                        resolve(false);
                    } else {
                        db.get("SELECT * FROM seats WHERE sid=$sid", {$sid: seat_id}, function (err, rows) {
                            if (err) {
                                resolve(false);
                            } else {
                                resolve(true);
                            }
                        })
                    }
                })
            }
        })
    });
}


function get_user_info_by_id(uid){
    return new Promise(function (resolve) {
        db.get('SELECT username, email, mobile, created_at FROM user WHERE uid=$uid', {'$uid': uid}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'user_info': rows, 'info': 'successful'}})
            }
        })
    })
}


function get_cinemas_info(){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM cinema", function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'cinemas': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_venues_info(cinema_id){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM venue WHERE cid=$cid", {$cid: cinema_id}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'venues': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_films_info(){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM movie", function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                for(let film of rows){
                    get_film_classification(film['film_id']).then((class_info)=>{
                        let class_arr = []
                        for (let class_name of class_info['data']['class']){
                            class_arr.push(class_name['cname'])
                        }
                        rows[rows.indexOf(film)]['classification'] = class_arr
                        if(rows.indexOf(film) === rows.length-1){
                            resolve({status: 1, data: {'films': rows, 'info': 'successful'}})
                        }

                    })
                }
            }
        });
    });
}


function get_film_classification(fid){
    return new Promise(function (resolve){
        db.all("SELECT cname FROM classification INNER JOIN film_classification fc on classification.cid = fc.cid WHERE fc.fid = $fid",
            {$fid: fid},
            function (err, rows){
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'class': rows, 'info': 'successful'}})
            }
        })
    })
}


function get_seats_map_info(venue_id){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM seats WHERE venus_id=$vid", {$vid: venue_id}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'seats': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_film_id_from_screening(sid){
    return new Promise(function (resolve){
        db.get("SELECT film_id FROM screening WHERE sid=$sid", {$sid: sid}, function (err, rows){
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'film_id': rows, 'info': 'successful'}})
            }
        })
    })
}


function get_booked_map_info(screening_id){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM booking WHERE screening_id=$screening_id", {$screening_id: screening_id}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'seats': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_screenings_info(cinema_id){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM screening INNER JOIN venue v ON screening.venue_id = v.vid INNER JOIN cinema c ON c.cid=v.cid WHERE c.cid=$cid", {$cid: cinema_id}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'screenings': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_cinema_film(film_id){
    return new Promise(function (resolve) {
        db.all("SELECT c.cid, c.name, c.location, c.info, c.score FROM cinema c " +
            "INNER JOIN venue v on c.cid = v.cid INNER JOIN screening s ON v.vid =s.venue_id WHERE " +
            "s.film_id=$fid GROUP BY name", {$fid: film_id}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'cinemas': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_screenings_film(cinema_id, fid){
    return new Promise(function (resolve) {
        db.all("SELECT * FROM screening INNER JOIN venue v ON screening.venue_id = v.vid " +
            "INNER JOIN cinema c ON c.cid=v.cid WHERE c.cid=$cid " +
            "AND screening.film_id=$fid", {$cid: cinema_id, $fid: fid}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'screenings': rows, 'info': 'successful'}})
            }
        });
    })
}


function get_booking_info(screening_id, seat_id){
    return new Promise(function (resolve) {
        db.get("SELECT * FROM booking WHERE screening_id=$screening_id AND seat_id=$seat_id", {
            $screening_id: screening_id,
            $seat_id: seat_id
        }, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'booking': rows, 'info': 'successful'}})
            }
        })
    })
}


function create_booking(uid, screening_id, seat_id, user_type, rand_str){
    return new Promise(function (resolve) {
        db.run("INSERT INTO booking(uid, screening_id, seat_id, user_type, secret) VALUES ($uid, $screening_id, $seat_id, $user_type, $secret)",
            {
                $uid: uid,
                $screening_id: screening_id,
                $seat_id: seat_id,
                $user_type: user_type,
                $secret: rand_str
            }
            , function (err, rows) {
                if (err) {
                    resolve({status: 0, data: {'info': err}})
                } else {
                    resolve({status: 1, data: {'secret': rand_str, 'info': 'successful'}})
                }
            });
    })
}


function user_action(uid, fid, type){
    return new Promise(function (resolve) {
        let current_time = new Date().Format("yyyy-MM-dd");
        db.all("SELECT cid FROM film_classification WHERE fid=$fid", {"$fid": fid}, function (err, rows){
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                for (let cid_val of rows){
                    db.run("INSERT INTO user_action(uid, type, cid, time) VALUES ($uid, $type, $cid, $time)", {$uid: uid, $cid: cid_val['cid'], $time: current_time, $type: type}, function (err, rows){
                        resolve({status: 0, data: {'info': 'done'}})
                    })
                }
            }
        })
    })
}


module.exports = {
    get_user_info,
    get_cinemas_info,
    get_venues_info,
    get_films_info,
    get_film_classification,
    get_seats_map_info,
    get_booked_map_info,
    get_cinema_film,
    get_screenings_film,
    get_screenings_info,
    get_uid,
    get_booking_info,
    create_booking,
    verify_booking,
    get_salt,
    register_user,
    update_pw,
    user_action,
    get_film_id_from_screening
}
