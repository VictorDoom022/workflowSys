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

                    <b-tabs content-class="mt-3">
                        <b-tab title="Task Created" active>
                            <TaskCreated :taskListID="taskListID" />
                        </b-tab>
                        <b-tab title="Create Task">
                            <p>I'm the second tab</p>
                        </b-tab>
                        <b-tab title="Completed Task">
                            <p>I'm a disabled tab!</p>
                        </b-tab>
                    </b-tabs>
                </main>
            </div>
        </div>
    </div>
</template>

<script>
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import Loading from '../../../components/Loading.vue'
import TaskCreated from '../../../components/user/TaskCreated.vue'

export default {
    props: ['taskListID'],
    components: { UserSideNav, UserTopNav, Loading, TaskCreated },
    data() {
        return {
            taskList: [],
            searchTerm: '',
        }
    },
    mounted() {

    },
    methods: {
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