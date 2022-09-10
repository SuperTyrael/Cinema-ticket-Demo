import Movies from "@/section/Movies";
import Accounts from "@/section/Accounts";
import Tickets from "@/section/Tickets";
import Default from "@/section/Default";
import VueRouter from "vue-router";
import TicketsDetail from "@/detail/TicketsDetail";
import AccountsDetail from "@/detail/AccountsDetail";
import Rooms from "@/section/Rooms";
import Orders from "@/section/Orders";
import RoomEdit from "@/edit/RoomEdit";
import Schedules from "@/section/Schedules";
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
        { path: '/Rooms', component: Rooms, name:'Rooms'},
        { path: '/Rooms/edit/:id', component: RoomEdit, name: 'RoomEdit'},
        { path: '/Tickets/detail/:id', component: TicketsDetail, name: 'TicketsDetail'},
        { path: '/Orders', component: Orders, name:'Orders'},
        { path: '/Schedules', component: Schedules, name:'Schedules'},
        { path: '/Analysis', component: Analysis, name:'Analysis'},
        { path: '/Analysis/Comparison', component: Comparison, name:'Comparison'}

    ]
})