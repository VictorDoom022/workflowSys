<template>
    <div class="container-fluid">

        <Loading v-if="isLoading" />

        <b-row v-if="taskList.length">
            <b-col md="6" v-for="task in searchTask" :key="task.id">
                <TaskItem :taskPageData="taskListPageData" :task="task" :userData="userData" :userDetailData="userDetailData" />
            </b-col> 
        </b-row>

        <h2 v-if="!taskList.length">No Task Yet</h2>
    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../Loading.vue'
import TaskItem from '../TaskItem.vue'

export default {
    // taskListPageData contains - groupID, teamID, taskListID
    props: ['taskListPageData', 'searchTerm', 'userData', 'userDetailData'],
    components: { Loading, TaskItem },
    data() {
        return {
            pageDataParsed: [],
            groupID: null,
            teamID: null,
            taskListID: null,
            taskList: [],
            isLoading: true,
        }
    },
    mounted() {
        this.pageDataParsed = JSON.parse(this.taskListPageData)
        this.groupID = this.pageDataParsed.groupID
        this.teamID = this.pageDataParsed.teamID
        this.taskListID = this.pageDataParsed.taskListID
        this.fetchTaskListData()
    },
    methods: {
        fetchTaskListData(){
            Vue.axios({
                url: '/task/getTaskByTaskListID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskListID: this.taskListID,
                },
            }).then((response) => {
                this.taskList = response.data
                this.isLoading = false
            })
        },
        navigateBack(){
            this.$router.go(-1)
        },
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
    },
    computed: {
        searchTask(){
            return this.taskList.filter((task) => {
                if(this.searchTerm == ''){
                    return task.task_name
                }else{
                    return task.task_name.toLowerCase().includes(this.searchTerm.toLowerCase())
                }
            })
        }
    },
}
</script>

<style>

</style>