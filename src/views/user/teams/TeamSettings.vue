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
                                                        <button class="btn btn-outline-primary btn-sm">Rename</button>
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
                                                        <b-icon class="mr-1" icon="chevron-right"></b-icon>
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
                                                        <b-icon class="mr-1" icon="chevron-right"></b-icon>
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
                                                        <button class="btn btn-outline-danger btn-sm">Delete</button>
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

        <SelectMember v-if="showModal" :groupID="this.groupID" :userList="userListForModal" :viewOnly="modalViewOnly" :type="modalType"/>
    
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
    props: ['teamID'],
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
        navigateBack(){
            this.$router.go(-1)
        },
    },
}
</script>

<style>

</style>