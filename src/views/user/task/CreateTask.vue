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
                                <div class="col-md-6">
                                    <div class="mb-3 d-flex">
                                        <label class="mt-2 mr-2">Color</label>
                                        <select type="text" v-model="taskColor" class="form-select" autocomplete="off">
                                            <option value="0" :selected="taskColor">Default</option>
                                            <option value="1">Blue</option>
                                            <option value="2">Red</option>
                                            <option value="3">Yellow</option>
                                            <option value="4">Green</option>
                                            <option value="5">Grey</option>
                                            <option value="6">Black</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3 d-flex">
                                        <label class="mt-2 mr-2">Priority</label>
                                        <select type="text" v-model="taskPriority" class="form-select" autocomplete="off">
                                            <option value="0"></option>
                                            <option value="1">Low</option>
                                            <option value="2" :selected="taskPriority">Medium (Default)</option>
                                            <option value="3">High</option>
                                            <option value="4">Very High</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-floating mb-3">
                                        <textarea type="text" v-model="taskDesc" class="form-control" placeholder="Task Description" style="height: 150px" autocomplete="off" required>
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
                                    <div class="mb-3">
                                        <label>Attach Files</label>
                                        <input class="form-control form-control-sm"  type="file" @change="onFileChange" multiple>
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
                                    <button class="btn btn-primary mb-3" type="submit">Save</button>
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
import ClassicEditor from '@ckeditor/ckeditor5-build-classic'

export default {
    // taskListPageData contains - groupID, teamID, taskListID
    props: ['taskListPageData'],
    components: { UserSideNav, UserTopNav },
    data() {
        return {
            pageDataParsed: [],
            groupID: null,
            teamID: null,
            taskListID: null,
            taskName : '',
            taskDesc: '',
            taskDetailedDesc: '',
            taskStatusMsg: '',
            taskColor: 0,
            taskPriority: 2,
            taskStartDate: '',
            taskDueDate: '',
            taskFiles: null,
            editor: ClassicEditor,
        }
    },
    mounted() {
        this.pageDataParsed = JSON.parse(this.taskListPageData)
        this.groupID = this.pageDataParsed.groupID
        this.teamID = this.pageDataParsed.teamID
        this.taskListID = this.pageDataParsed.taskListID
    },
    methods: {
        navigateBack(){
            var jsonPageData = {
                groupID: this.groupID,
                teamID: this.teamID,
                taskListID: this.taskListID,
            }
            this.$router.push({ name: 'TaskList', params: { taskListPageData: JSON.stringify(jsonPageData) }})
        },
        onFileChange(e){
            this.taskFiles = e.target.files
            console.log(this.taskFiles)
        },
        createTask(){
            let formData = new FormData()
            formData.append('userID', loggedInUserData.state.userData['user'].id)
            formData.append('taskListID', this.taskListID)
            formData.append('taskTeamID', this.teamID)
            formData.append('taskName', this.taskName)
            formData.append('taskDesc', this.taskDesc)
            formData.append('taskDetailedDesc', this.taskDetailedDesc)
            formData.append('taskStartDate', this.taskStartDate.length == 0 ? 'null' : this.taskStartDate)
            formData.append('taskDueDate', this.taskDueDate.length == 0 ? 'null' : this.taskDueDate)
            formData.append('taskStatusMsg', this.taskStatusMsg)
            formData.append('taskColor', this.taskColor)
            formData.append('taskPriority', this.taskPriority)

            if(this.taskFiles != null){
                for(var i = 0; i < this.taskFiles.length; i++){
                    formData.append('taskFiles[]', this.taskFiles[i])
                }
            }

            Vue.axios.post(
                '/task/createTask', 
                formData ,
                {
                    headers: {
                        Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                        'Content-Type': 'multipart/form-data'
                    },
                }
            ).then((response) => {
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
.ck-editor__editable {
    min-height: 200px;
}
</style>