<template>
  <div class="main">
      <UserSideNav />
      <main>
        <h1>Hey</h1>
      </main>
  </div>
</template>

<script>
import UserSideNav from '../../components/user/UserSideNav.vue'

export default {
    components: { UserSideNav },
    data() {

    },
}
</script>

<style scoped>
/* https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/Grid_Template_Areas */
.main{
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-auto-rows: minmax(100px, auto);
  grid-template-areas:
    /* "hd hd hd hd   hd   hd   hd   hd   hd" */
    "sd sd sd sd main main main main main main main main"
    /* "ft ft ft ft   ft   ft   ft   ft   ft"; */
}

main{
  grid-area: main;
}
</style>