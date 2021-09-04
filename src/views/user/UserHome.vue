<template>
  <div class="main">

    <UserTopNav @searchWord="searchFromNavBar" />
    <div class="container-fluid">
      <div class="row">
        <UserSideNav />

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

          <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Groups</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <button type="button" @click="showJoinGroupDialog()" class="btn btn-sm btn-primary mx-1">Join Group</button>
              <button type="button" @click="showEnterGroupNameDialog()" class="btn btn-sm btn-success mx-1">Create Group</button>
            </div>
          </div>

          <div v-if="isLoading" class="mx-auto">
              <div class="spinner-border text-dark" role="status" style="width: 3rem; height: 3rem;">
                  <span class="visually-hidden">Loading...</span>
              </div>
          </div>

          <div v-if="isLoading==false && groups.length == 0" class="mx-auto">
              <h1>No groups joined</h1>
          </div>

          <div v-if="groups.length !=0" class="container-fluid">
            <b-row>
              <b-col md="4" v-for="group in searchGroup" :key="group.id">
                <div @click="navigateToTeamList(group.id)" class="card border-light shadow mb-2 border-end border-bottom border-top-0 border-start-0" style="text-align:left; min-height:100px">
                      <div class="card-body">
                          <h4 class="card-title text-center">{{ group.group_name }}</h4>
                      </div>
                  </div>
              </b-col>  
            </b-row>
          </div>

        </main>

      </div>
    </div>
      
    <input type="hidden" id="textToCopy" :value="groupJoinCodeTemp">
  </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../components/user/UserSideNav.vue'
import UserTopNav from '../../components/user/UserTopNav.vue'
import loggedInUserData from '../../functions/loggedInUserData'

export default {
    components: { UserSideNav, UserTopNav },
    data() {
      return {
        groups: [],
        searchTerm: '',
        groupJoinCodeTemp: '',
        isLoading: true,
      }
    },
    mounted() {
        this.fetchGroupData()
    },
    methods: {
      fetchGroupData(){
        Vue.axios({
            url: '/group/userID/' + loggedInUserData.state.userData['user'].id,
            method: 'POST',
            headers: {
                Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                'Content-Type': 'application/json',
            },
            }
        ).then((response) => {
            this.groups = response.data
            this.isLoading = false
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
            if(!result.isDismissed){
              this.joinGroup(result.value)
            }    
        })
      },
      joinGroup(joinCode){
        Vue.axios({
            url: '/group/joinGroup',
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
      showEnterGroupNameDialog(){
        Vue.swal.fire({
            title: 'Enter new group name',
            input: 'text',
            inputPlaceholder: 'Name',
            confirmButtonColor: '#28a745',
            showCancelButton: true,
        }).then((result) => {
            if(!result.isDismissed){
              this.createGroup(result.value)
            }
        })
      },
      createGroup(newGroupName) {
        Vue.axios({
            url: '/createGroup',
            method: 'POST',
            headers: {
                Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                'Content-Type': 'application/json',
            },
            data: {
                groupName: newGroupName,
                userID: loggedInUserData.state.userData['user'].id,
            },
          }
        ).then((response) => {
            this.fetchGroupData()
            this.groupJoinCodeTemp = response.data.group_joinCode

            Vue.swal.fire({
              title: 'Your group\'s join code',
              text: this.groupJoinCodeTemp,
              confirmButtonText: 'Copy',
              confirmButtonColor: '#28a745',
              showCancelButton: true,
            }).then((result) => {
              if(result.isConfirmed){
                // select the hidden input
                let testingCodeToCopy = document.querySelector('#textToCopy')
                // change it to input type text since it cannot copy from input type hidden
                testingCodeToCopy.setAttribute('type', 'text')
                testingCodeToCopy.select()
                // copy the grouo code from the input field
                document.execCommand('copy')
                // set it back to hidden again & reset the variable
                testingCodeToCopy.setAttribute('type', 'hidden')
                this.groupJoinCodeTemp = ''
              }
            })
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
      navigateToTeamList(groupID){
        this.$router.push({ name: 'TeamList', params: { groupID: groupID }})
      },
      searchFromNavBar(searchWordFromNavBar){
        this.searchTerm = searchWordFromNavBar
      }
    },
    computed: {
      searchGroup(){
        return this.groups.filter((group) => {
          if(this.searchTerm == ''){
            return group.group_name
          }else{
            return group.group_name.toLowerCase().includes(this.searchTerm.toLowerCase())
          }
        })
      }
    }
}
</script>

<style scoped>
.card{
  cursor: pointer;
}
</style>