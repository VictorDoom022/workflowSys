<template>
  <div>
      <AdminTopNav />
      <h1>User Lists</h1>

      <div v-if="!users" class="mx-auto">
          <div class="spinner-border text-dark" role="status" style="width: 3rem; height: 3rem;">
              <span class="visually-hidden">Loading...</span>
          </div>
      </div>

      <b-container v-if="users">
          <b-row>

              <b-col md="12" class="mb-3">
                  <input type="text" v-model="searchTerm" class="form-control" placeholder="Search user...">
              </b-col>

              <b-col md="4" v-for="(user, index) in searchUser" :key="user.id">
                  <div @click="navigateToUserDetail(user.id)" class="card border-dark mb-2" style="text-align:left; min-height:100px">
                      <div class="card-body">
                          <h5 class="card-title">{{ user.name }}</h5>
                          <h6 class="card-subtitle text-muted">{{ user.email }}</h6>
                          <div class="card-text">
                              {{ userDetails[index].userDetail_status }}
                              <p class="text-success mb-0" v-if=" userDetails[index].userDetail_accEnable == 1">Enabled</p>
                              <p class="text-danger mb-0" v-if=" userDetails[index].userDetail_accEnable == 0">Banned</p>
                          </div>
                      </div>
                  </div>
              </b-col>              
          </b-row>
      </b-container>
  </div>
</template>

<script>
import AdminTopNav from '../../components/admin/AdminTopNav.vue'
import loggedInUserData from '../../functions/loggedInUserData'
import Vue from 'vue'

export default {
    components: { AdminTopNav },
    data() {
        return {
            users: [],
            userDetails: [],
            searchTerm: '',
        }
    },
    methods: {
        navigateToUserDetail(userID){
            this.$router.push({ name: 'UserDetails', params: { userID: userID } })
        }
    },
    computed: {
        searchUser(){
            return this.users.filter((user) => {
                if(this.searchTerm == ''){
                    return user.name
                }else{
                    return user.name.includes(this.searchTerm) || user.email.includes(this.searchTerm);
                }
            })
        }
    },
    mounted() {
        Vue.axios({
            url: 'users',
            method: 'GET',
            headers: {
                Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
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

<style scoped>
.card:hover{
  box-shadow: 0 5px 15px rgba(145, 92, 182, .4);
  transition: all 0.2s ease-in-out;
  cursor: pointer;
}
</style>