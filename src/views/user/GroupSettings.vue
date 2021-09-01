<template>
    <div>
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Group Settings
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
                                                    <p class="text-muted mb-0">View all members in the group</p>
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
                                                    <strong class="mb-0">View group admin</strong>
                                                    <p class="text-muted mb-0">View all admins in the group</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <b-icon class="mr-1" icon="chevron-right"></b-icon>
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
                                                    <strong class="mb-0">Rename group</strong>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <button @click="showRenameGroupDialog()" class="btn btn-outline-primary btn-sm">Rename</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">View all teams</strong>
                                                    <p class="text-muted mb-0">Some teams will not be shown in the group page. Check them out here!</p>
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
                                                    <strong class="mb-0">Set member as admin</strong>
                                                    <p class="text-muted mb-0">Add a new member to be the admin of your group</p>
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
                                                    <strong class="mb-0">Remove admin</strong>
                                                    <p class="text-muted mb-0">Revoke admin privileges</p>
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
                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Delete group</strong>
                                                    <p class="text-muted mb-0">Nuke everything related to this group</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <button @click="showConfirmDeleteGroupDialog()" class="btn btn-outline-danger btn-sm">Delete</button>
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
    </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../components/user/UserSideNav.vue'
import UserTopNav from '../../components/user/UserTopNav.vue'
import loggedInUserData from '../../functions/loggedInUserData'
import Loading from '../../components/Loading.vue'

export default {
    props: ['groupID'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            groupDetail: [],
            teamList: [],
            isAdmin: false,
        }
    },
    mounted() {
        this.fetchGroupDetail()
    },
    methods: {
        fetchGroupDetail(){
            Vue.axios({
                url: '/group/getGroupDetailByGroupUserID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                    userID: loggedInUserData.state.userData['user'].id,
                },
            }).then((response) => {
                this.groupDetail = response.data['group']
                this.teamList = response.data['team']
                this.checkUserAdmin()
            })
        },
        checkUserAdmin(){
            let adminList = this.groupDetail.group_adminList
            let adminListArr = adminList.split(',')
            
            for(let i = 0; i < adminListArr.length; i++){
                if(adminListArr[i] == loggedInUserData.state.userData['user'].id){
                    this.isAdmin = true;
                }
            }
        },
        navigateBack(){
            this.$router.go(-1)
        },
        showRenameGroupDialog(){
            Vue.swal.fire({
                title: 'Enter new group name',
                input: 'text',
                inputPlaceholder: 'Name',
                confirmButtonColor: '#28a745',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.renameGroup(result.value);
                }
            })
        },
        renameGroup(newGroupName){
            Vue.axios({
                url: '/group/renameGroup',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                    groupName: newGroupName
                },
            }).then((response) => {
                this.toastMessage(response)
            })
        },
        showConfirmDeleteGroupDialog(){
            Vue.swal.fire({
                title: 'Are you sure you want to delete the group?',
                text: 'Everthing related to this group will be deleted.',  
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Yes',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.deleteGroup();
                }
            })
        },
        deleteGroup(){
            Vue.axios({
                url: '/group/deleteGroup/' + this.groupID,
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                }
            }).then((response) => {
                this.toastMessage(response)
                this.$router.push({ name: 'UserHome'})
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
    }
}
</script>

<style>

</style>