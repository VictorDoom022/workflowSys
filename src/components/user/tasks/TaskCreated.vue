<template>
    <div class="container-fluid">

        <Loading v-if="isLoading" />

        <b-row v-if="taskList.length">
            <b-col md="12" v-for="task in searchTask" :key="task.id">
                <TaskItem :task="task" />
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
    props: ['taskListID', 'searchTerm'],
    components: { Loading, TaskItem },
    data() {
        return {
            taskList: [],
            isLoading: true,
        }
    },
    mounted() {
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