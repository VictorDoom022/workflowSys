<template>
    <b-modal v-model="modalShown" id="modal-1" title="Select member" @ok="okButtonClick">
        
        <input type="text" v-model="searchTerm" class="form-control" placeholder="Search member...">

        <div class="my-3">
            <div v-for="user in searchUser" :key="user.id" v-bind:class="{ shadow: selectedUserID.includes(user.id) }" @click="selectUser(user.id)" class="card my-1">
                <div class="card-body">
                    <h5 class="card-title">{{ user.name }}</h5>
                    <h6 class="card-subtitle mb-2 text-muted">{{ user.email }}</h6>
                </div>
            </div>
        </div>
    </b-modal>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../functions/loggedInUserData'
/*
    type 1 = set member as admin
*/
export default {
    props: ['groupID', 'userList', 'viewOnly', 'type'],
    data() {
        return {
            modalShown: true,
            searchTerm: '',
            selectedUserID : [],
        }
    },
    methods: {
        okButtonClick(){
            if(this.type == 1){
                this.setMemberAsAdmin()
            }else if(this.type == 2){
                this.removeMemberFromAdmin()
            }
        },
        selectUser(userID){
            if(!this.viewOnly){
                if(this.selectedUserID.includes(userID)) {
                    // remove selected if user being selected again
                    this.selectedUserID.splice(this.selectedUserID.indexOf(userID), 1)
                }else{
                    this.selectedUserID.push(userID);
                }
            } 
        },
        setMemberAsAdmin(){
            Vue.axios({
                url: '/group/setMemberAsAdmin',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID : this.groupID,
                    userList : this.selectedUserID.join(','),
                },
            }).then((response) => {
                this.toastMessage(response);
            })
        },
        removeMemberFromAdmin(){
            Vue.axios({
                url: '/group/removeMemberFromGroupAdmin',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID : this.groupID,
                    userList : this.selectedUserID.join(','),
                },
            }).then((response) => {
                this.toastMessage(response);
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
      searchUser(){
        return this.userList.filter((user) => {
          if(this.searchTerm == ''){
            return user.name
          }else{
            return user.name.toLowerCase().includes(this.searchTerm.toLowerCase()) || user.email.toLowerCase().includes(this.searchTerm.toLowerCase())
          }
        })
      }
    }
}
</script>

<style scoped>
.card:hover {
    cursor: pointer;
}
</style>