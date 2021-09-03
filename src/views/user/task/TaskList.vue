<template>
    <div>
        <UserTopNav @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Task List
                        </h1>
                    </div>

                    <div class="container-fluid">
                        <b-row>
                            <b-col md="4" v-for="task in searchTask" :key="task.id">
                                <div class="card border-dark mb-2" style="text-align:left; min-height:100px">
                                    <div class="card-body">
                                        <h4 class="card-title text-center">{{ task.task_name }}</h4>
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
    props: ['taskListID'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            taskList: [],
            searchTerm: '',
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