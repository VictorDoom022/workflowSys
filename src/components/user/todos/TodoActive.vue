<template>
    <div class="container-fluid">

        <Loading v-if="isLoading" />

        <b-row v-if="todoList.length">
            <b-col md="6" xl="4"  v-for="todo in searchTodo" :key="todo.id">
                <TodoItem :todo="todo" />
            </b-col> 
        </b-row>

        <h2 v-if="!todoList.length">No Active Todos Yet</h2>
    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../Loading.vue'
import TodoItem from '../TodoItem.vue'

export default {
    props: ['searchTerm'],
    components: { Loading, TodoItem },
    data(){
        return {
            isLoading: true,
            todoList: [],
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
                this.todoList = response.data
            })
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