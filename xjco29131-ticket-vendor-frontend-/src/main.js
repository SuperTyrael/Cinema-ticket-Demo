import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import App from '@/App.vue'
import vuetify from '@/plugins/vuetify';
import router from "@/router";
import store from "@/store"
const echarts = require("echarts");
Vue.use(VueAxios, axios)
Vue.config.productionTip = true
Vue.prototype.$echarts = echarts;

new Vue({
  vuetify,
  router,
  store,
  render: h => h(App)
}).$mount('#app')
