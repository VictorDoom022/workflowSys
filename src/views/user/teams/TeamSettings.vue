<template>
    <div>
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="isLoading"/>

                <main v-if="!isLoading" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Team Settings
                        </h1>
                    </div>

                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-12 col-lg-10 col-xl-8 mx-auto">
                                <div class="my-4">

                                    <strong class="mb-0">General</strong>

                                    <div class="list-group mb-5 shadow">
                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">View members</strong>
                                                    <p class="text-muted mb-0">View all members in the team</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <b-icon @click="showAllTeamMembersDialog()" class="mr-1" icon="chevron-right"></b-icon>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <strong v-if="isAdmin" class="mb-0">Admin</strong>

                                    <div v-if="isAdmin" class="list-group mb-5 shadow">
                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Rename team</strong>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <button @click="showRenameTeamDialog()" class="btn btn-outline-primary btn-sm">Rename</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Add member to team</strong>
                                                    <p class="text-muted mb-0">Add members from Group to your team</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <b-icon @click="addMemberToTeamDialog()" class="mr-1" icon="chevron-right"></b-icon>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Remove member from team</strong>
                                                    <p class="text-muted mb-0">Task related to user will be deleted</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <b-icon @click="removeMemberFromTeam()" class="mr-1" icon="chevron-right"></b-icon>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <strong class="mb-0 text-danger">Danger Zone</strong>

                                    <div class="list-group mb-5 shadow">
                                        <div v-if="isAdmin" class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Delete team</strong>
                                                    <p class="text-muted mb-0">Nuke everything related to this this</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <button @click="showConfirmDeleteTeamDialog()" class="btn btn-outline-danger btn-sm">Delete</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Quit team</strong>
                                                    <p class="text-muted mb-0">Task related to you will be deleted</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <button class="btn btn-outline-danger btn-sm">Quit</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <SelectMember v-if="showModal" :teamID="this.teamID" :groupID="this.groupID" :userList="userListForModal" :viewOnly="modalViewOnly" :type="modalType"/>
    
    </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import SelectMember from '../../../components/user/SelectMember.vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../../components/Loading.vue'

export default {
    props: ['groupID','teamID'],
    components: { UserSideNav, UserTopNav, Loading, SelectMember },
    data() {
        return {
            isAdmin: false,
            isLoading: true,
            showModal: false,
            userListForModal: null,
            modalViewOnly: false,
            modalType: 0,
        }
    },
    mounted() {
        this.checkIsUserAdmin()
    },
    methods: {
        checkIsUserAdmin(){
             Vue.axios({
                url: '/group/checkIsUserAdminByTeamID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    userID : loggedInUserData.state.userData['user'].id, 
                    teamID : this.teamID
                }
            }).then((response) => {
                this.isAdmin = response.data['message']
                this.isLoading = false;
            })
        },
        showAllTeamMembersDialog(){
            Vue.axios({
                url: '/team/getTeamUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    teamID: this.teamID,
                },
            }).then((response) => {
                this.userListForModal = response.data
                this.modalViewOnly = true;
                this.showModal = !this.showModal
            })
        },
        showRenameTeamDialog(){
            Vue.swal.fire({
                title: 'Enter new team name',
                input: 'text',
                inputPlaceholder: 'Name',
                confirmButtonColor: '#28a745',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.renameTeam(result.value);
                }
            })
        },
        renameTeam(newTeamName){
            Vue.axios({
                url: '/team/renameTeam',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    teamID : this.teamID,
                    teamName: newTeamName
                },
            }).then((response) => {
                this.toastMessage(response)
            })
        },
        addMemberToTeamDialog(){
            Vue.axios({
                url: '/team/getTeamUserDiff',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                    teamID: this.teamID,
                },
            }).then((response) => {
                this.userListForModal = response.data
                this.modalViewOnly = false
                this.modalType = 3
                this.showModal = !this.showModal
            })
        },
        removeMemberFromTeam(){
            Vue.axios({
                url: '/team/getTeamUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                    teamID: this.teamID,
                },
            }).then((response) => {
                this.userListForModal = response.data
                this.modalViewOnly = false
                this.modalType = 4
                this.showModal = !this.showModal
            })
        },
        showConfirmDeleteTeamDialog(){
            Vue.swal.fire({
                title: 'Are you sure you want to delete this team?',
                text: 'Everthing related to this team will be deleted.',  
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Yes',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.deleteTeam();
                }
            })
        },
        deleteTeam(){
            Vue.axios({
                url: '/team/deleteTeam',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    teamID: this.teamID,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.$router.push({ name: 'TeamList', params: { groupID: this.groupID }})
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
        navigateBack(){
            this.$router.go(-1)
        },
    },
}
</script>

<style>

</style>