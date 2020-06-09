cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "cordova-plugin-dingxin-sso.SSOLoginPlugin",
      "file": "plugins/cordova-plugin-dingxin-sso/www/SSOLoginPlugin.js",
      "pluginId": "cordova-plugin-dingxin-sso",
      "clobbers": [
        "cordova.dingxin.sso"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-dingxin-sso": "1.0.0",
    "cordova-plugin-whitelist": "1.3.3"
  };
});