import Movies from "@/section/Movies";
import Accounts from "@/section/Accounts";
import Tickets from "@/section/Tickets";
import Default from "@/section/Default";
import VueRouter from "vue-router";
import TicketsDetail from "@/detail/TicketsDetail";
import AccountsDetail from "@/detail/AccountsDetail";
import Cinemas from "@/section/Cinemas";
import Orders from "@/section/Orders";
import CinemaEdit from "@/edit/CinemaEdit";
import Venues from "@/section/Venues";
import Analysis from "@/section/Analysis";
import Comparison from "@/section/Comparision";

import Vue from 'vue'
Vue.use(VueRouter)


export default new VueRouter({
    routes : [
        { path: '/', component: Default, name:'Default' },
        { path: '/Movies', component: Movies, name:'Movies'},
        { path: '/Accounts', component: Accounts, name:'Accounts'},
        { path: '/Accounts/detail/:id', component: AccountsDetail, name:'AccountsDetail'},
        { path: '/Tickets', component: Tickets, name:'Tickets'},
        { path: '/Cinemas', component: Cinemas, name:'Cinemas'},
        { path: '/Cinemas/edit/:id', component: CinemaEdit, name: 'CinemaEdit'},
        { path: '/Tickets/detail/:id', component: TicketsDetail, name: 'TicketsDetail'},
        { path: '/Orders', component: Orders, name:'Orders'},
        { path: '/Venues', component: Venues, name:'Venues'},
        { path: '/Analysis', component: Analysis, name:'Analysis'},
        { path: '/Analysis/Comparison', component: Comparison, name:'Comparison'}

    ]
})