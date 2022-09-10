const sqlite3 = require("sqlite3");
const db = new sqlite3.Database('./db/movie.db');


function get_user_info(){
    return new Promise(function (resolve) {
        db.all('SELECT * FROM user', function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'users_info': rows, 'info': 'successful'}})
            }
        })
    })
}


function insert_film(film_info){
    return new Promise(function (resolve) {
        db.run('INSERT INTO movie(title,director,starring,blurb,classification,rank,release_time,running_time,is_released) VALUES ($title, $director, $starring, $blurb, $classification, $rank, $release_time, $running_time, $is_released)', {
            $title: film_info["film_name"],
            $director: film_info["director"],
            $starring: film_info["starring"],
            $blurb: film_info["blurb"],
            $certification: film_info["classification"],
            $rank: film_info["rank"],
            $release_time: film_info["release_time"],
            $running_time: film_info["running_time"],
            $is_released: film_info["is_released"]
        }, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'info': 'successful'}})
            }
        })
    })
}


function update_film(film_info){
    return new Promise(function (resolve) {
        db.run('UPDATE movie SET title = $title,director = $director,starring = $starring,blurb = $blurb,classification = $classification,rank = $rank,release_time = $release_time,running_time = $running_time,is_released = $is_released WHERE film_id= $film_id', {
            $film_id: film_info["film_id"],
            $title: film_info["film_name"],
            $director: film_info["director"],
            $starring: film_info["starring"],
            $blurb: film_info["blurb"],
            $certification: film_info["classification"],
            $rank: film_info["rank"],
            $release_time: film_info["release_time"],
            $running_time: film_info["running_time"],
            $is_released: film_info["is_released"]
        }, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'info': 'successful'}})
            }
        })
    })
}


function delete_film(film_id){
    return new Promise(function (resolve) {
        db.run('DELETE FROM movie WHERE film_id=$film_id', {$film_id: film_id}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'info': 'successful'}})
            }
        })
    })
}


function search_film(film_name){
    return new Promise(function (resolve) {
        db.run('SELECT * FROM movie WHERE title LIKE %$title%', {$title: film_name}, function (err, rows) {
            if (err) {
                resolve({status: 0, data: {'info': err}})
            } else {
                resolve({status: 1, data: {'info': 'successful'}})
            }
        })
    })
}


module.exports={
    get_user_info,
    insert_film,
    update_film,
    delete_film,
    search_film
}
