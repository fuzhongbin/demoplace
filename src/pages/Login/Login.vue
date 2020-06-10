<template>
  <div class="login">
    <header class="app-header">
      <i class="app-header_button"></i>
      <div class="app-header_title">
        <p>title</p>
      </div>
      <i class="app-header_button"></i>
    </header>
    <div>
      <p>login sso</p>
      <p>{{inType}}</p>
      <button v-if="isCordova" @click="loginSSO()">loginSSO</button>
      <div v-if="isCordova">
        {{ssoStr}}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "login",
  data() {
    return {
      inType: window.cordova ? "in cordova platform" : "no cordova platform",
      isCordova: window.cordova ? true : false,
      ssoInfo: {},
      ssoStr: `请点击按钮获取登录信息`
    };
  },
  components: {},
  methods: {
    loginSSO() {
      var _self = this;
      console.log(`loginSSO`);
      cordova.dingxin.sso.login(
        success => {
          let data = JSON.parse(success);
          _self.ssoStr = success;
          _self.ssoInfo = data;
          // this.localLogin(data);
          console.log(`sso login: ${success}`, `json parse: ${data}`);
          console.log("登陆鼎信成功")
        },
        error => {
          _self.ssoStr = `获取信息失败请重新登录`;
        },
        "2",
        "com.csg.mobileark"
      );
    }
  }
};
</script>

<style lang="scss" scoped>
</style>

