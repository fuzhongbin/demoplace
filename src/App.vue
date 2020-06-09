<template>
  <router-view/>
</template>

<script>
import environment from 'environment';
import httpService from './services/httpServices'

export default {
  name: "App",
  mounted() {
    console.log(environment);
    // console.log(this.$loading);
    // let loading = this.$loading({ fullscreen: true });
    httpService.ranking();
    // setTimeout(() => {
    //   loading.close();
    // }, 3000);
  }
};
</script>
