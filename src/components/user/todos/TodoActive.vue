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
    props: ['selectedSortType', 'searchTerm'],
    components: { Loading, TodoItem },
    data(){
        return {
            isLoading: true,
            todoList: [],
            selectSortOptions: ['Default', 'Name Desc', 'Updated Asc', 'Updated Desc', 'Created At Asc', 'Create At Desc'],
        }
    },
    mounted(){
        this.fetchTodoListData()
    },
    watch: {
        immediate: true,
        selectedSortType: function (newVal, oldVal){
            this.sortList()
        }
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
        sortList(){
            if(this.selectSortOptions[0] == this.selectedSortType.target.value){
                this.todoList.sort((a,b) => {
                    return a.todo_name.localeCompare(b.todo_name)
                })
            }else if(this.selectSortOptions[1] == this.selectedSortType.target.value){
                this.todoList.sort((a,b) => {
                    return b.todo_name.localeCompare(a.todo_name)
                })
            }else if(this.selectSortOptions[2] == this.selectedSortType.target.value){
                this.todoList.sort((a,b) => {
                    return new Date(a.updated_at) - new Date(b.updated_at)
                })
            }else if(this.selectSortOptions[3] == this.selectedSortType.target.value){
                this.todoList.sort((a,b) => {
                    return new Date(b.updated_at) - new Date(a.updated_at)
                })
            }else if(this.selectSortOptions[4] == this.selectedSortType.target.value){
                this.todoList.sort((a,b) => {
                    return new Date(a.created_at) - new Date(b.created_at)
                })
            }else if(this.selectSortOptions[5] == this.selectedSortType.target.value){
                this.todoList.sort((a,b) => {
                    return new Date(b.created_at) - new Date(a.created_at)
                })
            }
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