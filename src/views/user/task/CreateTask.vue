<template>
    <div>
        <UserTopNav/>
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Create Task
                        </h1>
                    </div>

                    <div class="container-fluid">
                        <form @submit.prevent="createTask()" class="form">
                            <div class="row">
                                <h1>Basic Task Info</h1>
                                <div class="col-md-6 ">
                                    <div class="form-floating mb-3">
                                        <input type="text" v-model="taskName" class="form-control" placeholder="Task Name" autocomplete="off" required>
                                        <label>Task Name</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="text" v-model="taskStatusMsg" class="form-control" placeholder="Task Name" autocomplete="off" required>
                                        <label>Task Status</label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-floating mb-3">
                                        <textarea type="text" v-model="taskDesc" class="form-control" placeholder="Task Description" style="height: 150px" autocomplete="off" required>
                                        </textarea>
                                        <label>Task Description</label>
                                    </div>
                                </div>

                                <div class="col-md-12 mb-2 border-top"></div>

                                <h1>Extras</h1>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="date" v-model="taskStartDate" class="form-control" placeholder="Start Date" autocomplete="off">
                                        <label>Start Date</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="date" v-model="taskDueDate" class="form-control" placeholder="Due Date" autocomplete="off">
                                        <label>Due Date</label>
                                    </div>
                                </div>

                                <div class="submit col-md-12 d-grid">
                                    <button class="btn btn-primary" type="submit">Save</button>
                                </div>
                            </div>
                        </form>
                    </div>
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

export default {
    props: ['teamID', 'taskListID'],
    components: { UserSideNav, UserTopNav },
    data() {
        return {
            taskName : '',
            taskDesc: '',
            taskStatusMsg: '',
            taskStartDate: '',
            taskDueDate: '',
        }
    },
    methods: {
        navigateBack(){
            this.$router.go(-1)
        },
        createTask(){
            Vue.axios({
                url: '/task/createTask',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    userID : loggedInUserData.state.userData['user'].id,
                    taskListID : this.taskListID,
                    taskTeamID : this.teamID,
                    taskName : this.taskName,
                    taskDesc : this.taskDesc,
                    taskStartDate : this.taskStartDate.length == 0 ? 'null' : this.taskStartDate,
                    taskDueDate : this.taskDueDate.length == 0 ? 'null' : this.taskDueDate,
                    taskStatusMsg : this.taskStatusMsg,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.$router.push({ name: 'TaskList', params: { teamID: this.teamID, taskListID: this.taskListID }})
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
    },
}
</script>

<style>

</style>