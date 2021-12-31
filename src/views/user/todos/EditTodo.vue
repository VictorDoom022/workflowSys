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
                            Edit Todo
                        </h1>
                    </div>

                    <div class="container-fluid">
                        <form @submit.prevent="editTodo()" class="form">
                            <div class="row">
                                <h1>Todo Basic Info</h1>
                                <div class="col-md-6 ">
                                    <div class="form-floating mb-3">
                                        <input type="text" v-model="todoName" class="form-control" placeholder="Todo Name" autocomplete="off" required>
                                        <label>Todo Name</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="text" v-model="todoStatusMsg" class="form-control" placeholder="Todo Status" autocomplete="off" required>
                                        <label>Todo Status</label>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-floating mb-3">
                                        <textarea type="text" v-model="todoDesc" class="form-control" placeholder="Todo Description" style="height: 150px" autocomplete="off" required>
                                        </textarea>
                                        <label>Todo Description</label>
                                    </div>
                                </div>

                                <div class="col-md-12 mb-2 border-top"></div>

                                <h1>Extras</h1>
                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="date" v-model="todoStartDate" class="form-control" placeholder="Start Date" autocomplete="off">
                                        <label>Start Date</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-floating mb-3">
                                        <input type="date" v-model="todoDueDate" class="form-control" placeholder="Due Date" autocomplete="off">
                                        <label>Due Date</label>
                                    </div>
                                </div>

                                <div class="submit col-md-12 d-grid">
                                    <button class="btn btn-primary" type="submit">Save</button>
                                    <input @click="showToggleTodoStatusDialog()" type="button" class="btn btn-secondary mt-2" value="Archive/Unarchive"/>
                                    <input @click="showDeleteTaskDialog()" type="button" class="btn btn-danger my-2" value="Delete"/>
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
    props: ['todoID'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            isLoading: true,
            todo: [],
            todoName : '',
            todoDesc: '',
            todoStatusMsg: '',
            todoStartDate: '',
            todoDueDate: '',
        }
    },
    mounted(){
        this.fetchTodoData()
    },
    methods: {
        fetchTodoData(){
            Vue.axios({
                url: '/todo/getTodoByID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    todoID : this.todoID,
                },
            }).then((response) => {
                this.todo = response.data
                this.setTodoData()
            })
        },
        setTodoData(){
            this.todoName  = this.todo.todo_name
            this.todoDesc = this.todo.todo_desc
            this.todoStatusMsg = this.todo.todo_statusMsg
            this.todoStartDate = this.todo.todo_startDate
            this.todoDueDate = this.todo.todo_dueDate
            this.isLoading = false
        },
        showToggleTodoStatusDialog(){
            Vue.axios({
                url: '/todo/changeTodoStatus',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    todoID : this.todoID,
                    todoStatus : this.todo.todo_status,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.$router.push({ name: 'TodoList' })
            })
        },
        editTodo(){
            Vue.axios({
                url: '/todo/updateTodo',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    todoID : this.todoID,
                    todoName : this.todoName,
                    todoDesc : this.todoDesc,
                    todoStatusMsg : this.todoStatusMsg,
                    todoStartDate : this.todoStartDate.length == 0 ? 'null' : this.todoStartDate,
                    todoDueDate : this.todoDueDate.length == 0 ? 'null' : this.todoDueDate,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.fetchTodoData()
            })
        },
        showDeleteTaskDialog(){
            Vue.swal.fire({
                title: 'Are you sure you want to delete this to-do?',  
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Yes',
                showCancelButton: true,
            }).then((result) => {
                if(!result.isDismissed){
                    this.deleteTodo();
                }
            })
        },
        deleteTodo(){
            Vue.axios({
                url: '/todo/deleteTodoById/' + this.todoID,
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
            this.$router.push({ name: 'TodoList' })
        },
    },
}
</script>

<style>

</style>