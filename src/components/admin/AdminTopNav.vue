<template>
   <div>
  <b-navbar toggleable="md" type="dark" variant="dark">
    <router-link :to="{ name: 'AdminHome' }">
      <b-navbar-brand href="#">
        Workflow Sys
      </b-navbar-brand>
    </router-link>

    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav>
        <router-link :to="{ name: 'AdminHome' }">
          <b-nav-item>
            Users
          </b-nav-item>
        </router-link>
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
import storeData from '../../functions/storeData'

export default {
  data() {
    return {
      username: '',
    }
  },
  methods: {
    logout(){
      Vue.axios.post(
        'logout', {
          headers: {
            'Authorization' : 'Bearer ' + storeData.state.userData['token'].toString(),
            'Content-Type': 'application/json',
              
          },
        }
      ).then((response) => {
        storeData.dispatch('createUserSession', null).then(() => {
          this.$router.push('/')
        })
      })
    },
  },
  mounted() {
    if(storeData.state.userData != null){
      this.username = storeData.state.userData['user'].name
    }else{
      this.$router.push('/')
    }
  }
}
</script>

<style>

</style>