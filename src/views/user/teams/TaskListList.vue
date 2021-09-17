<template>
    <div>
        <UserTopNav @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="taskListList.length == 0"/>

                <main v-if="taskListList.length !=0" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Team ({{ teamDetail.team_name }})
                        </h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button type="button" @click="navigateToTeamSettings()" class="btn btn-sm btn-primary mx-1">Settings</button>
                        </div>
                    </div>

                    <div class="container-fluid">
                        <b-row>
                            <b-col md="4" v-for="taskList in searchTaskList" :key="taskList.id" @click="navigateToTaskList(taskList.id)">
                                <div class="card border-light shadow mb-2 border-end border-bottom border-top-0 border-start-0" style="text-align:left; min-height:100px">
                                    <div class="card-body">
                                        <h2 class="card-title align-middle text-center">{{ taskList.taskList_userID }}</h2>
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
    // taskListListPageData contains - groupID, teamID
    props: ['taskListListPageData'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            pageDataParsed: [],
            groupID: null,
            teamID: null,
            userData: [],
            userDetailData: [],
            teamDetail: [],
            taskListList: [],
            newTaskListList: [],
            isLoading: true,
            searchTerm: '',
        }
    },
    mounted() {
        this.pageDataParsed = JSON.parse(this.taskListListPageData)
        this.groupID = this.pageDataParsed.groupID
        this.teamID = this.pageDataParsed.teamID
        this.fetchTeamData()
    },
    methods: {
        fetchTeamData(){
            Vue.axios({
                url: '/users',
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.userData = response.data['user'];
                this.userDetailData = response.data['userDetail'];

                Vue.axios({
                    url: '/team/getTeamID',
                    method: 'POST',
                    headers: {
                        Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                        'Content-Type': 'application/json',
                    },
                    data: {
                        teamID : this.teamID
                    }
                }).then((response) => {
                    this.teamDetail = response.data['team']
                    this.taskListList = response.data['taskList']
                    this.replaceTaskListListData()
                    this.isLoading = false
                })
            })
        },
        replaceTaskListListData(){
            for(var i = 0; i < this.taskListList.length; i++) {
                for(var j = i; j < this.userData.length; j++) {
                    if(this.taskListList[i].taskList_userID == this.userData[j].id){
                        // replace userID with user name
                        this.taskListList[i].taskList_userID = this.userData[j].name
                    }
                }
            }
            this.newTaskListList = this.taskListList
        },
        navigateBack(){
            this.$router.push({ name: 'TeamList', params: { groupID: this.groupID }})
        },
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
        navigateToTeamSettings(){
            var jsonPageData = {
                groupID: this.groupID,
                teamID: this.teamID,
            }
            this.$router.push({ name: 'TeamSettings', params: { teamPageData: JSON.stringify(jsonPageData) }})
        },
        navigateToTaskList(taskListID){
            var jsonPageData = {
                groupID: this.groupID,
                teamID: this.teamID,
                taskListID: taskListID,
            }
            this.$router.push({ name: 'TaskList', params: { taskListPageData: JSON.stringify(jsonPageData) }})
        }
    },
    computed: {
        searchTaskList(){
            return this.newTaskListList.filter((task) => {
                if(this.searchTerm == ''){
                    return task.taskList_userID
                }else{
                    return task.taskList_userID.toLowerCase().includes(this.searchTerm.toLowerCase());
                }
            })
            
        }
    },
}
</script>

<style scoped>
.card{
  cursor: pointer;
  transition: .5s ease;
}

.card:hover{
  box-shadow: 0 1rem 3rem rgb(0 0 0 / 18%) !important;
  transition: .3s ease;
}
</style>