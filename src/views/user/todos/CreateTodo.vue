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
                            Create Todo
                        </h1>
                    </div>

                    <div class="container-fluid">
                        <form @submit.prevent="createTodo()" class="form">
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
            todoName : '',
            todoDesc: '',
            todoStatusMsg: '',
            todoStartDate: '',
            todoDueDate: '',
        }
    },
    methods: {
        navigateBack(){
            this.$router.go(-1)
        },
        createTodo(){
            Vue.axios({
                url: '/todo/createTodo',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    userID : loggedInUserData.state.userData['user'].id,
                    todoName : this.todoName,
                    todoDesc : this.todoDesc,
                    todoStartDate : this.todoStartDate.length == 0 ? 'null' : this.todoStartDate,
                    todoDueDate : this.todoDueDate.length == 0 ? 'null' : this.todoDueDate,
                    todoStatusMsg : this.todoStatusMsg,
                },
            }).then((response) => {
                this.toastMessage(response)
                this.$router.push({ name: 'TodoList' })
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