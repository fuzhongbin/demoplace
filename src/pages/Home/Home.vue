<template>
  <div class="home">
    <header class="app-header">
      <i class="app-header_button"></i>
      <div class="app-header_title">
        <p>title</p>
      </div>
      <i class="app-header_button"></i>
    </header>
    <div>
      <p>home</p>
      <p>{{inType}}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "home",
  data() {
    return {
      inType: window.cordova ? "in cordova platform" : "no cordova platform"
    };
  },
  components: {}
};
</script>

<style lang="scss" scoped>
</style>

