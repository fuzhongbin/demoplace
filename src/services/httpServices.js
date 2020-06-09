import $request from './axios';
import environment from "environment";
// import Vue from 'vue'

let httpService = {
  method: {
    post: 'post',
    get: 'get',
    form: 'form',
  },
  api: environment.production || environment.test ? environment.baseUrl : 'api',
  logError(error, url = '', params = {}) {
    // 对象的方法使用箭头函数定义时，不能通过this进行调用。
    // https://segmentfault.com/a/1190000018119191#articleHeader2
    try {
      var err = {
        err: 1,
        url,
        params
      };
      // err.response = error.response;
      err.status = error.response.status;
      err.statusText = error.response.statusText;
      console.warn('axios catch error => ', err);
      return err
    } catch (e) {
      console.warn(e);
      return e
    }
  },
  get(url, params) {
    // this.loading.show();
    // let promise = new Promise((resolve, reject) => {
    return $request.get(url, params).then(
      result => {
        return result.data;
        // Vue.$vux.loading.hide()
      },
      error => this.logError(error)
    )
    // });
    // return promise;
  },
  postForm(url, params) {
    // let promise = new Promise((resolve, reject) => {
    return $request.postForm(url, params).then(
      result => {
        return result.data;
        // Vue.$vux.loading.hide()
      },
      error => this.logError(error)
    )
    // });
    // return promise;
  },
  post(url, params) {
    // let promise = new Promise((resolve, reject) => {
    return $request.post(url, params).then(
      result => {
        return result.data;
        // Vue.$vux.loading.hide()
      },
      error => this.logError(error)
    )
    // });
    // return promise;
  },
  ranking(params) {
    return this.get(this.api + '/ranking', params);
  }
}

export default httpService;