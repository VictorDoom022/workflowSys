<template>
   <div>
  <b-navbar toggleable="md" type="dark" variant="dark">
    <b-navbar-brand href="#">
      <router-link :to="{ name: 'AdminHome' }" class="navbar-brand">
        Workflow Sys
      </router-link>
    </b-navbar-brand>

    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav>
        <b-nav-item>
          <router-link :to="{ name: 'AdminHome' }" class="nav-link">
              Users
          </router-link>
        </b-nav-item>
      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">

        <b-nav-item-dropdown right>
          <!-- Using 'button-content' slot -->
          <template #button-content>
            <em>{{ username }}</em>
          </template>
          <b-dropdown-item @click="logout">Sign Out</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../functions/loggedInUserData'

export default {
  data() {
    return {
      username: '',
    }
  },
  methods: {
    logout(){
      Vue.axios({
        url: 'logout',
        method: 'POST',
        headers: {
            Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
            'Content-Type': 'application/json',
          },
        }
      ).then((response) => {
        loggedInUserData.dispatch('createUserSession', null).then(() => {
          this.$router.push('/')
        })
      })
    },
  },
  mounted() {
    if(loggedInUserData.state.userData != null && loggedInUserData.state.userData['user'].position == "admin"){
      this.username = loggedInUserData.state.userData['user'].name
    }else{
      this.$router.push('/')
    }
  }
}
</script>

<style>

</style>