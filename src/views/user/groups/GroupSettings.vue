<template>
    <div>
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="isLoading"/>

                <main v-if="groupDetail.length != 0" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
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
                                                    <strong class="mb-0">View all members</strong>
                                                    <p class="text-muted mb-0">View all members in the group</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <b-icon @click="showAllMembersDialog()" class="mr-1" icon="chevron-right"></b-icon>
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
                                                        <b-icon @click="showAllAdminDialog()" class="mr-1" icon="chevron-right"></b-icon>
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
                                                    <strong class="mb-0">Join code</strong>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <input class="joinCodeInputText" id="joinCode" type="text" :value="groupDetail.group_joinCode" readonly>
                                                        <b-icon @click="copyJoinCode()" class="mr-1 copyIcon" icon="clipboard"></b-icon>
                                                        <button @click="generateNewJoinCode()" class="btn btn-outline-primary btn-sm">Generate new join code</button>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>

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
                                                        <b-icon @click="showAllTeamDialog()" class="mr-1" icon="chevron-right"></b-icon>
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
                                                        <b-icon @click="showSetAdminDialog()" class="mr-1" icon="chevron-right"></b-icon>
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
                                                        <b-icon @click="showRemoveAdminDialog()" class="mr-1" icon="chevron-right"></b-icon>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="list-group-item">
                                            <div class="row align-items-center">
                                                <div class="col">
                                                    <strong class="mb-0">Remove user</strong>
                                                    <p class="text-muted mb-0">Remove user from group</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <b-icon @click="showRemoveMemberDialog()" class="mr-1" icon="chevron-right"></b-icon>
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
                                                    <strong class="mb-0">Leave group</strong>
                                                    <p class="text-muted mb-0">Nuke everything related to you in this group</p>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="custom-control custom-switch">
                                                        <button @click="showConfirmLeaveGroupDialog()" class="btn btn-outline-danger btn-sm">Leave</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div v-if="isAdmin" class="list-group-item">
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

        <SelectMember v-if="showModal" @modalShown="toggleModal" :groupID="this.groupID" :userList="userListForModal" :viewOnly="modalViewOnly" :type="modalType"/>
        <SelectTeam v-if="showTeamModal" @teamModalShown="toggleTeamModal" :groupID="groupID" :teamList="teamListForModal"/>
    </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import SelectMember from '../../../components/user/SelectMember.vue'
import SelectTeam from '../../../components/user/SelectTeam.vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../../components/Loading.vue'

export default {
    props: ['groupID'],
    components: { UserSideNav, UserTopNav, Loading, SelectMember, SelectTeam },
    data() {
        return {
            groupDetail: [],
            teamList: [],
            isAdmin: false,
            showModal: false,
            showTeamModal: false,
            userListForModal: null,
            teamListForModal: null,
            modalViewOnly: false,
            modalType: 0,
            isLoading: true,
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
                if(response.data['group'] != null){
                    this.groupDetail = response.data['group']
                    this.teamList = response.data['team']
                    this.checkUserAdmin()
                }else{
                    this.$router.push({name : "Error404" })
                }
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
            this.isLoading = false
        },
        navigateBack(){
            this.$router.push({ name: 'TeamList', params: { groupID: this.groupID }})
        },
        toggleModal(isModalShown){
            this.showModal = isModalShown
        },
        toggleTeamModal(isTeamModalShown){
            this.showTeamModal = isTeamModalShown
        },
        showAllMembersDialog(){
            this.isLoading = true
            Vue.axios({
                url: '/group/getGroupUserByGroupID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                },
            }).then((response) => {
                this.isLoading = false
                this.userListForModal = response.data
                this.modalViewOnly = true;
                this.showModal = !this.showModal
            })
        },
        showAllAdminDialog(){
            this.isLoading = true
            Vue.axios({
                url: '/group/getGroupAdminUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                },
            }).then((response) => {
                this.isLoading = false
                this.userListForModal = response.data
                this.modalViewOnly = true;
                this.showModal = !this.showModal
            })
        },
        showAllTeamDialog(){
            Vue.axios({
                url: '/group/getGroupTeamByGroupID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                },
            }).then((response) => {
                this.teamListForModal = response.data
                this.modalViewOnly = true
                this.showTeamModal = !this.showTeamModal
            })
        },
        showSetAdminDialog(){
            this.isLoading = true
            Vue.axios({
                url: '/group/getGroupNonAdminUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                },
            }).then((response) => {
                this.isLoading = false
                this.userListForModal = response.data
                this.modalViewOnly = false
                this.modalType = 1
                this.showModal = !this.showModal
            })
        },
        showRemoveAdminDialog(){
            this.isLoading = true
            Vue.axios({
                url: '/group/getGroupAdminUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                },
            }).then((response) => {
                this.isLoading = false
                // remove current logged in user from the list
                for(var i = 0; i < response.data.length; i++){
                    if(response.data[i].id == loggedInUserData.state.userData['user'].id){
                        response.data.splice(i, 1);
                    }
                }
                this.userListForModal = response.data
                this.modalViewOnly = false
                this.modalType = 2
                this.showModal = !this.showModal
            })
        },
        showRemoveMemberDialog(){
            this.isLoading = true
            Vue.axios({
                url: '/group/getGroupUserByGroupID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                },
            }).then((response) => {
                this.isLoading = false
                // remove current logged in user from the list
                for(var i = 0; i < response.data.length; i++){
                    if(response.data[i].id == loggedInUserData.state.userData['user'].id){
                        response.data.splice(i, 1);
                    }
                }
                this.userListForModal = response.data
                this.modalViewOnly = false
                this.modalType = 6
                this.showModal = !this.showModal
            })
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
        showConfirmLeaveGroupDialog(){
            Vue.swal.fire({
                title: 'Are you sure you want to leave the group?',
                text: 'Everthing related to you in this group will be deleted.',  
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Yes',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.leaveGroup();
                }
            })
        },
        leaveGroup(){
            Vue.axios({
                url: '/group/removeMemberFromGroup',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID : this.groupID,
                    userList : loggedInUserData.state.userData['user'].id,
                },
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
        copyJoinCode(){
            // select the hidden input
            let testingCodeToCopy = document.querySelector('#joinCode')

            testingCodeToCopy.select()
            // copy the grouo code from the input field
            document.execCommand('copy')
        },
        generateNewJoinCode(){
            Vue.axios({
                url: '/group/generateNewGroupJoinCode',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID : this.groupID,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.fetchGroupDetail()
            })
        }
    }
}
</script>

<style scoped>
.copyIcon:hover {
    cursor: pointer;
}

.joinCodeInputText {
    border: none;
    text-align: right;
    font-style: italic;
    font-weight: 300;
}

.joinCodeInputText:focus {
    border: none;
    outline :none;
}

.b-icon {
    cursor: pointer;
}
</style>