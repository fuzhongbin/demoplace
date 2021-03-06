import Vue from 'vue';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import 'normalize.css/normalize.css';
// import './styles/index.scss';
import App from './App.vue';
import router from './router';

Vue.use(ElementUI);

Vue.config.productionTip = false;

let init = () => {
  new Vue({
    router,
    render: h => h(App),
  }).$mount('#app');
}

if (window.cordova) {
  document.addEventListener('deviceready', init(), false)
} else {
  init()
}