<template>
    <b-modal v-model="modalShown" id="modal-1" title="Select member" @ok="okButtonClick">
        
        <input type="text" v-model="searchTerm" class="form-control" placeholder="Search member...">

        <div class="my-3" v-if="userList.length">
            <div v-for="user in searchUser" :key="user.id" v-bind:class="{ shadow: selectedUserID.includes(user.id) }" @click="selectUser(user.id)" :id="'userID-'+user.id" class="card my-1">
                <div class="card-body">
                    <h5 class="card-title">{{ user.name }}</h5>
                    <h6 class="card-subtitle mb-2 text-muted">{{ user.email }}</h6>
                </div>

                <b-tooltip :target="'userID-'+user.id" triggers="hover">
                    <p @click="navigateToUserInfo(user.id)" class="mb-0" style="cursor:pointer;">View User Info</p>
                </b-tooltip>
            </div>
        </div>

        <div class="my-3" v-if="!userList.length">
            <h2 class="text-center">No users</h2>
        </div>
    </b-modal>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../functions/loggedInUserData'
/*
    type 1 = set member as admin
    type 2 = remove member from admin
    type 3 = add member to team
    type 4 = remove member from team
    type 5 = assign task to team member
    type 6 = remove user from group
*/
export default {
    props: ['groupID', 'teamID', 'taskID', 'userList', 'viewOnly', 'type'],
    data() {
        return {
            modalShown: true,
            searchTerm: '',
            selectedUserID : [],
        }
    },
    watch: {
        modalShown: function(val) {
            this.$emit('modalShown', val)
        }
    }, 
    methods: {
        okButtonClick(){
            if(this.type == 1){
                this.setMemberAsAdmin()
            }else if(this.type == 2){
                this.removeMemberFromAdmin()
            }else if(this.type == 3){
                this.addMemberToTeam()
            }else if(this.type == 4){
                this.removeMemberFromTeam()
            }else if(this.type == 5){
                this.assignTaskToTeamMember()
            }else if(this.type == 6) {
                this.removeUserFromGroup()
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
        addMemberToTeam(){
            Vue.axios({
                url: '/team/addMemberToTeam',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    teamID : this.teamID,
                    userList : this.selectedUserID.join(','),
                },
            }).then((response) => {
                this.toastMessage(response);
            })
        },
        removeMemberFromTeam(){
            Vue.axios({
                url: '/team/removeMemberFromTeam',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    teamID : this.teamID,
                    userList : this.selectedUserID.join(','),
                },
            }).then((response) => {
                this.toastMessage(response);
            })
        },
        assignTaskToTeamMember(){
            Vue.axios({
                url: '/task/assignTask',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskID : this.taskID,
                    assignedUserID : this.selectedUserID[0],
                    taskAssignedDate : this.convertDateTimeToEpoch(Date()),
                },
            }).then((response) => {
                this.toastMessage(response);
            })
        },
        removeUserFromGroup(){
            Vue.axios({
                url: '/group/removeMemberFromGroup',
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
                this.toastMessage(response)
                this.$router.push({ name: 'UserHome'})
            })
        },
        convertDateTimeToEpoch(dateTime){
            return Date.parse(dateTime)
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
        navigateToUserInfo(userID){
            this.$router.push({ name: 'UserInfo', params: { userID: userID }})
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