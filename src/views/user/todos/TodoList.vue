<template>
    <div>
        <UserTopNav @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="isLoading" />

                <main v-if="!isLoading" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            Todo List
                        </h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button @click="navigateToCreateTodo()" type="button" class="btn btn-sm btn-primary mx-1">Create Todo</button>
                        </div>
                    </div>

                    <div class="container-fluid">
                        <b-row v-if="todoList.length">
                            <b-col md="6" v-for="todo in searchTodo" :key="todo.id">
                                <TodoItem :todo="todo" />
                            </b-col> 
                        </b-row>

                        <h2 v-if="!todoList.length">No Todos Yet</h2>
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
import TodoItem from '../../../components/user/TodoItem.vue'

export default {
    components: { UserSideNav, UserTopNav, Loading, TodoItem },
    data(){
        return {
            isLoading: true,
            todoList: [],
            searchTerm: '',
        }
    },
    mounted(){
        this.fetchTodoListData()
    },
    methods: {
        fetchTodoListData(){
            Vue.axios({
                url: '/todo/getToDoByUserID',
                method: 'POST', 
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    userID: loggedInUserData.state.userData['user'].id,
                },
            }).then((response) => {
                this.isLoading = false
                console.log(response.data);
                this.todoList = response.data
            })
        },
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
        navigateToCreateTodo(){
            this.$router.push({ name: 'CreateTodo' })
        },
    },
    computed: {
        searchTodo(){
            return this.todoList.filter((todo) => {
                if(this.searchTerm == ''){
                    return todo.todo_name
                }else{
                    return todo.todo_name.toLowerCase().includes(this.searchTerm.toLowerCase())
                }
            })
        }
    },
}
</script>

<style>

</style>