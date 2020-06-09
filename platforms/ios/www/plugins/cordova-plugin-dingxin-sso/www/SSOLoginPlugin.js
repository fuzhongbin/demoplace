cordova.define("cordova-plugin-dingxin-sso.SSOLoginPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

module.exports = {
		
		checkPermission:function(){
			exec(null,null,"SSO","checkPermission",[]);
		},
		login:function(success,fail,pack){
			// type = 1; sso v1登录
			// type = 2; sso v2登录
			exec(success,fail,"SSO","ssoLogin",[pack]);
		},
		loginDebugiOS:function(success,fail,packageID){
			exec(success,fail,"SSO","ssoLogin",[packageID,debug]);
		},
        fetchParams:function(success,fail,pack){
            // type = 1; sso v1登录
            // type = 2; sso v2登录
            exec(success,fail,"SSO","ssoLogin",[pack]);
        }
	}
});
