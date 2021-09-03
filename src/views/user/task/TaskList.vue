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
                            <TaskCreated :taskListID="taskListID" :searchTerm="searchTerm" />
                        </b-tab>
                        <b-tab title="Assigned To You">
                            <TaskAssigend :taskListID="taskListID" :searchTerm="searchTerm" />
                        </b-tab>
                        <b-tab title="Completed Task">
                            <TaskCompleted :taskListID="taskListID" :searchTerm="searchTerm" />
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
import TaskCreated from '../../../components/user/tasks/TaskCreated.vue'
import TaskAssigend from '../../../components/user/tasks/TaskAssigend.vue'
import TaskCompleted from '../../../components/user/tasks/TaskCompleted.vue'

export default {
    props: ['taskListID'],
    components: { UserSideNav, UserTopNav, Loading, TaskCreated, TaskAssigend, TaskCompleted },
    data() {
        return {
            taskList: [],
            searchTerm: '',
        }
    },
    watch: {
        searchTerm: function(value) {
            this.$emit('searchTerm', this.searchTerm);
        }
    },
    methods: {
        navigateBack(){
            this.$router.go(-1)
        },
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
    },
}
</script>

<style>
</style>