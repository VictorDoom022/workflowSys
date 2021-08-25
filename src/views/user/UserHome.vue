<template>
  <div class="main">
      <UserSideNav />
      <main>
        <b-jumbotron header="Groups">
          <p>Hello there~</p>
          <b-button variant="primary mr-1">Join Group</b-button>
          <b-button variant="success">Create Group</b-button>
        </b-jumbotron>
      </main>
  </div>
</template>

<script>
import UserSideNav from '../../components/user/UserSideNav.vue'

export default {
    components: { UserSideNav },
    data() {
      return {
        
      }
    },
}
</script>

<style scoped>
/* https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/Grid_Template_Areas */
.main{
  display: grid;
  grid-template-columns: 0fr 3fr;
  gap: 0em;
  grid-template-areas:
    "sd main"
}

main{
  grid-area: main;
}
</style>