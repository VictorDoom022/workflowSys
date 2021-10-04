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

                                <div class="d-flex justify-content-center">
                                    <p class="text-muted mb-1 mx-3">Created by: {{ convertUserIDToName(taskUserCreateID) }}</p>
                                    <p class="text-muted mb-1 mx-3">Created on: {{ convertDBDateToString(taskData.created_at) }}</p>
                                    <p class="text-muted mb-1 mx-3">Last updated on: {{ convertDBDateToString(taskData.updated_at) }}</p>
                                </div>
                                
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
                                <div class="col-md-6">
                                    <div class="mb-3 d-flex">
                                        <label class="mt-2 mr-2">Color</label>
                                        <select type="text" v-model="taskColor" class="form-select" autocomplete="off">
                                            <option value="0" :selected="taskColor">Default</option>
                                            <option value="1" :selected="taskColor">Blue</option>
                                            <option value="2" :selected="taskColor">Red</option>
                                            <option value="3" :selected="taskColor">Yellow</option>
                                            <option value="4" :selected="taskColor">Green</option>
                                            <option value="5" :selected="taskColor">Grey</option>
                                            <option value="6" :selected="taskColor">Black</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3 d-flex">
                                        <label class="mt-2 mr-2">Priority</label>
                                        <select type="text" v-model="taskPriority" class="form-select" autocomplete="off">
                                            <option value="0" :selected="taskPriority">Very Low</option>
                                            <option value="1" :selected="taskPriority">Low</option>
                                            <option value="2" :selected="taskPriority">Medium (Default)</option>
                                            <option value="3" :selected="taskPriority">High</option>
                                            <option value="4" :selected="taskPriority">Very High</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-floating mb-3">
                                        <textarea type="text" v-model="taskDesc" :disabled="!allowEdit" class="form-control" placeholder="Task Description" style="height: 150px" autocomplete="off" required>
                                        </textarea>
                                        <label>Task Description</label>
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label>Task Detailed Description</label>
                                        <ckeditor v-model="taskDetailedDesc" :editor="editor"></ckeditor>
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <div class="list-group mb-3">
                                        <label>Attached Files</label>
                                        <div v-for="(file, index) in taskFileInfo" :key="index">
                                            <a @click="downloadFile(file.fileName)" class="list-group-item list-group-item-action" href="#">{{ file.fileName }}</a>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-2 text-center">
                                    <h6 class="fw-bold mt-2">
                                        <span v-if="taskData.task_assignedMemberID.length">
                                            Currently assigend to: {{ getLastAssigendUser(taskData.task_assignedMemberID) }}
                                        </span>
                                        <span v-if="!taskData.task_assignedMemberID.length">
                                            Not assigend
                                        </span>
                                    </h6>
                                </div>

                                <div class="col-md-6">
                                    <div class="row">
                                        <div class="col-md-6 d-grid mb-2">
                                            <input @click="showSelectUserDialog()" :disabled="!allowEdit" class="btn btn-success" type="button" value="Assign User">
                                        </div>
                                        <div class="col-md-6 d-grid mb-2">
                                            <input @click="navigateToAssignHistory()" class="btn btn-warning" type="button" value="View assign history">
                                        </div>
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
                                    <input :disabled="!allowEdit" @click="showToggleTaskStatusDialog()" type="button" class="btn btn-info my-2" value="Mark/Unmark as complete"/>
                                    <input :disabled="!allowEdit" @click="showDeleteTaskDialog()" type="button" class="btn btn-danger my-2" value="Delete"/>
                                </div>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <SelectMember v-if="showModal" @modalShown="toggleModal" :taskID="taskID" :userList="userListForModal" :viewOnly="modalViewOnly" :type="modalType"/>

    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import Loading from '../../../components/Loading.vue'
import SelectMember from '../../../components/user/SelectMember.vue'
import ClassicEditor from '@ckeditor/ckeditor5-build-classic'

export default {
    // taskPageData contains - groupID, teamID, taskListID, taskID
    props: ['taskPageData'],
    components: { UserSideNav, UserTopNav, Loading, SelectMember },
    data() {
        return {
            pageDataParsed: [],
            groupID: null,
            teamID: null,
            taskListID: null,
            taskID: null,
            isLoading: true,
            allowEdit: false,
            taskData: [],
            userData: [],
            userDetailData: [],
            taskName : '',
            taskDesc: '',
            taskDetailedDesc: '',
            taskStatusMsg: '',
            taskColor: null,
            taskPriority: null,
            taskStartDate: '',
            taskDueDate: '',
            taskUserCreateID: '',
            taskAssignedUserID: '',
            showModal: false,
            userListForModal: null,
            modalViewOnly: false,
            modalType: 0,
            taskFiles: null,
            taskFilePath: '',
            taskFileInfo: null,
            editor: ClassicEditor,
        }
    },
    mounted() {
        this.pageDataParsed = JSON.parse(this.taskPageData)
        this.groupID = this.pageDataParsed.groupID
        this.teamID = this.pageDataParsed.teamID
        this.taskListID = this.pageDataParsed.taskListID
        this.taskID = this.pageDataParsed.taskID
        this.fetchTaskData()
        this.fetchUserData()
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
                if(response.data.length == 0){
                    this.$router.push({name : "Error404" })
                }else{
                    this.taskData = response.data
                    this.setTaskData()
                }
            })
        },
        setTaskData(){
            this.taskName = this.taskData.task_name
            this.taskDesc = this.taskData.task_desc
            this.taskDetailedDesc = this.taskData.task_detailedDesc
            this.taskStatusMsg = this.taskData.task_statusMsg
            this.taskColor = this.taskData.task_color
            this.taskPriority = this.taskData.task_priority
            this.taskStartDate = this.taskData.task_startDate
            this.taskDueDate = this.taskData.task_dueDate
            this.taskUserCreateID = this.taskData.task_userCreateID
            this.taskAssignedUserID = this.taskData.task_assignedMemberID
            this.taskFilePath = this.taskData.task_filePath
            this.fetchFiles()
            this.checkAllowToEdit()
        },
        fetchFiles(){
            Vue.axios({
                url: '/task/getTaskFilesByPath',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    filePath : this.taskFilePath,
                },
            }).then((response) => {
                this.taskFileInfo = response.data

            })
        },
        downloadFile(fileName){
            Vue.axios({
                url: '/task/downloadFileByPath',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    fileName : fileName,
                    filePath : this.taskFilePath,
                },
            }).then((response) => {
                const url = window.URL.createObjectURL(new Blob([response.data]));
                const link = document.createElement('a');
                link.href = url;
                link.setAttribute('download', fileName);
                document.body.appendChild(link);
                link.click();
            })
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
        fetchUserData(){
            this.isLoading = true
            Vue.axios({
                url: '/users',
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.isLoading = false
                this.userData = response.data['user'];
                this.userDetailData = response.data['userDetail'];
            })
        },
        convertUserIDToName(userID){
            for(var i=0; i < this.userData.length; i++){
                if(userID == this.userData[i].id){
                    return this.userData[i].name
                }
            }
        },
        convertDBDateToString(dbDate){
            let dateStr = new Date(dbDate)
            let dateToDisplay = dateStr.getFullYear() + '/' + dateStr.getMonth() + '/' + dateStr.getDate() + ' ' + dateStr.getHours() + ':' + dateStr.getMinutes()
            return dateToDisplay
        },
        toggleModal(isModalShown){
            this.showModal = isModalShown
        },
        showSelectUserDialog(){
            Vue.axios({
                url: '/team/getTeamUser',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    teamID : this.teamID,
                },
            }).then((response) => {
                this.userListForModal = response.data
                this.modalViewOnly = false
                this.modalType = 5
                this.showModal = !this.showModal
            })
        },
        getLastAssigendUser(taskAssignUserList){
            var taskAssignUserListArr = taskAssignUserList.split(',')
            // get last element of array
            return this.convertUserIDToName(taskAssignUserListArr[taskAssignUserListArr.length-1])
        },
        showToggleTaskStatusDialog(){
            Vue.swal.fire({
                title: 'Are you sure you want to mark/unmark this task as complete?',  
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Yes',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.toggleTaskStatus();
                }
            })
        },
        toggleTaskStatus(){
            Vue.axios({
                url: '/task/changeTaskStatus',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskID : this.taskID,
                    taskStatus : this.taskData.task_status,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.$router.back()
            })
        },
        showDeleteTaskDialog(){
            Vue.swal.fire({
                title: 'Are you sure you want to delete this task?',  
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Yes',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.deleteTask();
                }
            })
        },
        deleteTask(){
            Vue.axios({
                url: '/task/deleteTaskByTaskID/' + this.taskID,
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.toastMessage(response)
                this.$router.back()
            })
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
                    taskDetailedDesc : this.taskDetailedDesc,
                    taskStartDate : this.taskStartDate.length == 0 ? 'null' : this.taskStartDate,
                    taskDueDate : this.taskDueDate.length == 0 ? 'null' : this.taskDueDate,
                    taskStatusMsg : this.taskStatusMsg,
                    taskColor : this.taskColor,
                    taskPriority : this.taskPriority,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.fetchTaskData()
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
            var jsonPageData = {
                groupID: this.groupID,
                teamID: this.teamID,
                taskListID: this.taskListID,
            }
            this.$router.push({ name: 'TaskList', params: { taskListPageData: JSON.stringify(jsonPageData) }})
        },
        navigateToAssignHistory(){
            this.$router.push({ name: 'TaskAssignedHistory', params: { 
                userList: JSON.stringify(this.userData), 
                assigendUserList: JSON.stringify(this.taskData.task_assignedMemberID), 
                assigendDateList: JSON.stringify(this.taskData.task_assignedDate), 
                } 
            })
        },
    },
}
</script>

<style>

</style>