import axios from 'axios';
import qs from 'qs';
import environment from "environment";

// "Content-Type": "application/x-www-form-urlencoded;charset=utf-8;"
// "Content-Type": "application/json"
// "Content-Type": "multipart/form-data"

const axiosConfig = {
  baseURL: environment.production ? environment.domain : '',
  headers: {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json",
  }
};
/**
 * 使用application/x-www-form-urlencoded要用qs进行序列化
 */
const request = {
  post(url, params) {
    return axios.post(url, params, axiosConfig);
  },
  postForm(url, params) {
    let config = Object.assign({}, axiosConfig);
    config.headers["Content-Type"] = `application/x-www-form-urlencoded;charset=utf-8;`;
    return axios.post(url, qs.stringify(params), config);
  },
  get(url, params) {
    let config = Object.assign({}, axiosConfig);
    if (params) {
      config.params = params;
    }
    return axios.get(url, config);
  }
}

export default request;