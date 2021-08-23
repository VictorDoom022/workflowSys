<template>
  <div>
      <AdminTopNav />
      <h1>User Lists</h1>

      <b-container>
          <b-row>
              <b-col md="4" v-for="(user, index) in users" :key="user.id">
                  <div class="card border-dark mb-2" style="text-align:left; min-height:100px">
                      <div class="card-body">
                          <h5 class="card-title">{{ user.name }}</h5>
                          <h6 class="card-subtitle">{{ user.email }}</h6>
                          <p class="card-text">{{ userDetails[index].userDetail_status }}</p>
                      </div>
                  </div>
              </b-col>              
          </b-row>
      </b-container>
  </div>
</template>

<script>
import AdminTopNav from '../../components/admin/AdminTopNav.vue'
import storeData from '../../functions/storeData'
import Vue from 'vue'

export default {
    components: { AdminTopNav },
    data() {
        return {
            users: [],
            userDetails: [],
        }
    },
    mounted() {
        Vue.axios({
            url: 'users',
            method: 'GET',
            headers: {
                Authorization : 'Bearer ' + storeData.state.userData['token'],
                'Content-Type': 'application/json',
            },
            }
        ).then((response) => {
            this.users = response.data['user']
            this.userDetails = response.data['userDetail']
        })
    }
}
</script>

<style>
.card:hover{
  box-shadow: 0 5px 15px rgba(145, 92, 182, .4);
  transition: all 0.2s ease-in-out;
  cursor: pointer;
}
</style>