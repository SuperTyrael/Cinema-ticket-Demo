const assert = require('assert');
const indexRouter = require('../routes/index');
const usersRouter = require('../routes/users');
const adminRouter = require('../routes/admin');
const authRouter = require('../routes/auth');
const guestRouter = require('../routes/guest');
const chai = require('chai')
const app = require('../app');
const should = require('should');
const chaiHttp = require('chai-http')
chai.use(chaiHttp);


describe('test', () => {
    it('test', () => {
        return chai.request(app)
            .get('/users')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .get('/users/user_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .get('/users/user_recommend')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .get('/guest/cinemas_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .get('/guest/films_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .get('/admin/users_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/venues_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/film_class_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/seats_map_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/booked_map_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/cinema_film')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/screenings_film')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/guest/screenings_info')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/users/user_click')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/users/booking')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/admin/update_film')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/admin/delete_film')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/admin/search_film')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/auth/register')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
    it('test', () => {
        return chai.request(app)
            .post('/auth/login')
            .then(res => {
                res.should.have.property('status', 200)
            })
            .catch(err => {
                throw err
            })
    })
})
