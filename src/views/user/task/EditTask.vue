<template>
    <div>
        <UserTopNav/>
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="isLoading"/>

                <main v-if="!isLoading" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Edit Task
                        </h1>
                    </div>

                    <div class="container-fluid">
                        <form @submit.prevent="editTask()" class="form">
                            <div class="row">
                                <h1>Basic Task Info</h1>
                                <div class="col-md-6 ">
                                    <div class="form-floating mb-3">
                                        <input type="text" v-model="taskName" :disabled="!allowEdit" class="form-control" placeholder="Task Name" autocomplete="off" required>
                                        <label>Task Name</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="text" v-model="taskStatusMsg" :disabled="!allowEdit" class="form-control" placeholder="Task Name" autocomplete="off" required>
                                        <label>Task Status</label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-floating mb-3">
                                        <textarea type="text" v-model="taskDesc" :disabled="!allowEdit" class="form-control" placeholder="Task Description" style="height: 150px" autocomplete="off" required>
                                        </textarea>
                                        <label>Task Description</label>
                                    </div>
                                </div>

                                <div class="col-md-12 mb-2 border-top"></div>

                                <h1>Extras</h1>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="date" v-model="taskStartDate" :disabled="!allowEdit" class="form-control" placeholder="Start Date" autocomplete="off">
                                        <label>Start Date</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="date" v-model="taskDueDate" :disabled="!allowEdit" class="form-control" placeholder="Due Date" autocomplete="off">
                                        <label>Due Date</label>
                                    </div>
                                </div>

                                <div class="submit col-md-12 d-grid">
                                    <button :disabled="!allowEdit" class="btn btn-primary" type="submit">Edit</button>
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
import Loading from '../../../components/Loading.vue'

export default {
    props: ['taskID'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            isLoading: true,
            allowEdit: false,
            taskData: [],
            taskName : '',
            taskDesc: '',
            taskStatusMsg: '',
            taskStartDate: '',
            taskDueDate: '',
            taskUserCreateID: '',
            taskAssignedUserID: '',
        }
    },
    mounted() {
        this.fetchTaskData()
    },
    methods: {
        fetchTaskData(){
            Vue.axios({
                url: '/task/getTaskByID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskID : this.taskID,
                },
            }).then((response) => {
                this.taskData = response.data
                this.setTaskData()
                console.log(this.taskData)
            })
        },
        setTaskData(){
            this.taskName = this.taskData.task_name
            this.taskDesc = this.taskData.task_desc
            this.taskStatusMsg = this.taskData.task_statusMsg
            this.taskStartDate = this.taskData.task_startDate
            this.taskDueDate = this.taskData.task_dueDate
            this.taskUserCreateID = this.taskData.task_userCreateID
            this.taskAssignedUserID = this.taskData.task_assignedMemberID
            this.checkAllowToEdit()
        },
        checkAllowToEdit(){
            var isTaskCreator = false
            var isAssignedUser = false
            var tempTaskAssignUserIDArr = this.taskAssignedUserID.split(',')

            if(loggedInUserData.state.userData['user'].id == this.taskUserCreateID){
                isTaskCreator = true
            }

            for(var i = 0; i < tempTaskAssignUserIDArr.length; i++){
                if(tempTaskAssignUserIDArr[i] == loggedInUserData.state.userData['user'].id){
                    isAssignedUser = true
                }
            }

            if(isTaskCreator || isAssignedUser){
                this.allowEdit = true
            }else{
                this.allowEdit = false
            }
            this.isLoading = false
        },
        editTask(){
            Vue.axios({
                url: '/task/updateTask',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskID : this.taskID,
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
        navigateBack(){
            this.$router.go(-1)
        },
    },
}
</script>

<style>

</style>