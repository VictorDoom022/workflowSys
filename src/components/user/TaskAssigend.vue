<template>
  <div class="container-fluid">
        <b-row>
            <b-col md="12" v-for="task in searchTask" :key="task.id">
                <TaskItem :task="task" />
            </b-col> 
        </b-row>
    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../functions/loggedInUserData'
import TaskItem from './TaskItem.vue'

export default {
    props: ['taskListID', 'searchTerm'],
    components: { TaskItem },
    data() {
        return {
            taskList: [],
        }
    },
    mounted() {
        console.log('taskAssigendMounted')
        this.fetchTaskListAssignedData()
    },
    methods: {
        fetchTaskListAssignedData(){
            Vue.axios({
                url: '/task/taskAssignedToUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskListID: this.taskListID,
                    'userID'  :  loggedInUserData.state.userData['user'].id,
                },
            }).then((response) => {
                this.taskList = response.data;
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