<template>
    <div>
        <UserTopNav @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="teamList.length ==0"/>

                <main v-if="teamList.length !=0" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Group ({{ groupDetail.group_name }})
                        </h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button type="button" @click="navigateToGroupSettings()" class="btn btn-sm btn-primary mx-1">Settings</button>
                            <button v-if="isAdmin" @click="showEnterTeamNameDialog()" type="button" class="btn btn-sm btn-success mx-1">Create Team</button>
                        </div>
                    </div>

                    <div class="container-fluid">
                        <b-row>
                            <b-col md="4" v-for="team in searchTeam" :key="team.id">
                                <div @click="navigateToTaskListList(team.id)" class="card border-dark mb-2" style="text-align:left; min-height:100px">
                                    <div class="card-body">
                                        <h4 class="card-title text-center">{{ team.team_name }}</h4>
                                    </div>
                                </div>
                            </b-col> 
                        </b-row>
                    </div>

                </main>

            </div>
        </div>
    </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../../components/Loading.vue'

export default {
    props: ['groupID'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            groupDetail: [],
            teamList: [],
            searchTerm: '',
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
        showEnterTeamNameDialog(){
            Vue.swal.fire({
                title: 'Enter new team name',
                input: 'text',
                inputPlaceholder: 'Name',
                confirmButtonColor: '#28a745',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.createTeam(result.value)
                }
            })
        },
        createTeam(newTeamName){
            Vue.axios({
                url: '/team/createTeam',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                    userID: loggedInUserData.state.userData['user'].id,
                    teamName: newTeamName
                },
            }).then((response) => {
                this.fetchGroupDetail()
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
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
        navigateToGroupSettings(){
            this.$router.push({ name: 'GroupSettings', params: { groupID: this.groupID }})
        },
        navigateToTaskListList(teamID){
            this.$router.push({ name: 'TaskListList', params: { groupID: this.groupID, teamID: teamID}})
        }
    },
    computed: {
        searchTeam(){
            return this.teamList.filter((team) => {
                if(this.searchTerm == ''){
                    return team.team_name
                }else{
                    return team.team_name.toLowerCase().includes(this.searchTerm.toLowerCase())
                }
            })
        }
    }
}
</script>

<style scoped>
.card {
    cursor: pointer;
}
</style>