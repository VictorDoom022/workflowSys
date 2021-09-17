<template>
    <div>
        <UserTopNav @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="!userData.length"/>

                <main v-if="userData.length" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Task List
                        </h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button type="button" @click="navigateToCreateTask()" class="btn btn-sm btn-primary mx-1">Create Task</button>
                        </div>
                    </div>

                    <b-tabs content-class="mt-3" align="center" fill>
                        <b-tab title="Task Created" active>
                            <TaskCreated :taskListPageData="taskListPageData" :searchTerm="searchTerm" :userData="userData" :userDetailData="userDetailData" />
                        </b-tab>
                        <b-tab title="Assigned To You">
                            <TaskAssigend :taskListPageData="taskListPageData" :searchTerm="searchTerm" :userData="userData" :userDetailData="userDetailData" />
                        </b-tab>
                        <b-tab title="Completed Task">
                            <TaskCompleted :taskListPageData="taskListPageData" :searchTerm="searchTerm" :userData="userData" :userDetailData="userDetailData" />
                        </b-tab>
                    </b-tabs>
                </main>
            </div>
        </div>
    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import Loading from '../../../components/Loading.vue'
import TaskCreated from '../../../components/user/tasks/TaskCreated.vue'
import TaskAssigend from '../../../components/user/tasks/TaskAssigend.vue'
import TaskCompleted from '../../../components/user/tasks/TaskCompleted.vue'

export default {
    // taskListPageData contains - groupID, teamID, taskListID
    props: ['taskListPageData'],
    components: { UserSideNav, UserTopNav, Loading, TaskCreated, TaskAssigend, TaskCompleted },
    data() {
        return {
            pageDataParsed: [],
            groupID: null,
            teamID: null,
            taskListID: null,
            taskList: [],
            userData: [],
            userDetailData: [],
            searchTerm: '',
        }
    },
    watch: {
        searchTerm: function(value) {
            this.$emit('searchTerm', this.searchTerm);
        }
    },
    mounted() {
        this.pageDataParsed = JSON.parse(this.taskListPageData)
        this.groupID = this.pageDataParsed.groupID
        this.teamID = this.pageDataParsed.teamID
        this.taskListID = this.pageDataParsed.taskListID
        this.fetchUserData()
    },
    methods: {
        fetchUserData(){
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
            })
        },
        navigateBack(){
            this.$router.go(-1)
        },
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
        navigateToCreateTask(){
            this.$router.push({ name: 'CreateTask', params: { teamID: this.teamID, taskListID: this.taskListID } })
        }
    },
}
</script>

<style>
</style>