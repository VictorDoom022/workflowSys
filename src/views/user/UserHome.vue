<template>
  <div class="main">
      <UserSideNav />
      <main>
        <b-jumbotron header="Groups">
          <p>Hello there~</p>
          <b-button @click="showJoinGroupDialog()" variant="primary mr-1">Join Group</b-button>
          <b-button variant="success">Create Group</b-button>
        </b-jumbotron>

        <div v-if="groups.length == 0" class="mx-auto">
            <div class="spinner-border text-dark" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>

        <div v-if="groups.length !=0" class="container-fluid">
          <b-row>
            <b-col md="12" class="mb-3">
                <input type="text" v-model="searchTerm" class="form-control" placeholder="Search groups...">
            </b-col>

            <b-col md="4" v-for="group in searchGroup" :key="group.id">
              <div class="card border-dark mb-2" style="text-align:left; min-height:100px">
                    <div class="card-body">
                        <h4 class="card-title text-center">{{ group.group_name }}</h4>
                    </div>
                </div>
            </b-col>  
          </b-row>
        </div>

      </main>
  </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../components/user/UserSideNav.vue'
import loggedInUserData from '../../functions/loggedInUserData'

export default {
    components: { UserSideNav },
    data() {
      return {
        groups: [],
        searchTerm: '',
      }
    },
    mounted() {
        this.fetchGroupData()
    },
    methods: {
      fetchGroupData(){
        Vue.axios({
            url: 'http://localhost:8000/api/group/userID/' + loggedInUserData.state.userData['user'].id,
            method: 'POST',
            headers: {
                Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                'Content-Type': 'application/json',
            },
            }
        ).then((response) => {
            this.groups = response.data
        })
      },
      showJoinGroupDialog() {
        Vue.swal.fire({
            title: 'Enter join code',
            input: 'text',
            inputPlaceholder: 'Code',
            confirmButtonColor: '#28a745',
            showCancelButton: true,
        }).then((result) => {
            this.joinGroup(result.value)
        })
      },
      joinGroup(joinCode){
        Vue.axios({
            url: 'http://localhost:8000/api/group/joinGroup',
            method: 'POST',
            headers: {
                Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                'Content-Type': 'application/json',
            },
            data: {
                userID: loggedInUserData.state.userData['user'].id,
                joinCode: joinCode,
            },
          }
        ).then((response) => {
            this.fetchGroupData()
            this.toastMessage(response)
        })
      },
      toastMessage(response) {
        Vue.swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            icon: response.status == 200 ? 'success' : 'error',
            title: response.data['message']
        })
      },
    },
    computed: {
      searchGroup(){
        return this.groups.filter((group) => {
          if(this.searchTerm == ''){
            return group.group_name
          }else{
            return group.group_name.includes(this.searchTerm)
          }
        })
      }
    }
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

.card{
  cursor: pointer;
}
</style>