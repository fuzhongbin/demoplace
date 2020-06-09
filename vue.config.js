// import DefinePlugin from 'DefinePlugin';
const path = require('path');
const environment = require('./src/environment/env')

function resolvePath(dir) {
  return path.join(__dirname, dir)
}

function getEnv() {
  let env = resolvePath((process.env.NODE_ENV === 'production')
    ? './src/environment/env.prod.js'
    : './src/environment/env.test.js');
  if (process.env.NODE_ENV === 'development') {
    env = resolvePath('./src/environment/env.js')
  }
  return env;
}

module.exports = {
  outputDir: 'www',
  productionSourceMap: process.env.NODE_ENV === 'production' ? false : true,
  lintOnSave: false,
  configureWebpack: {
    resolve: {
      extensions: ['.js', '.json', '.vue'],
      alias: {
        'environment': getEnv()
      }
    },
    plugins: [
    ]
  },
  publicPath: './',
  devServer: {
    open: process.platform === "darwin",
    port: 9000,
    proxy: {
      '/api': {
        target: environment.baseUrl,
        changeOrigin: true, // 跨域
        secure: false,  //https
        pathRewrite: {
          '^/api': ''
        }
      }
    },
  },
  chainWebpack: config => {
    // console.log(`NODE_ENV: ${process.env.NODE_ENV}`)
    if (process.env.NODE_ENV === 'production') {

    } else {

    }
  }
};
