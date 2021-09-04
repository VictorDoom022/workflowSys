<template>
    <div>
        <UserTopNav @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            Todo List
                        </h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button @click="navigateToCreateTodo()" type="button" class="btn btn-sm btn-primary mx-1">Create Todo</button>
                        </div>
                    </div>

                    <b-tabs content-class="mt-3">
                        <b-tab title="Active" active>
                            <TodoActive />
                        </b-tab>
                        <b-tab title="Archive">
                            <TodoArchive />
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
import TodoActive from '../../../components/user/todos/TodoActive.vue'
import TodoArchive from '../../../components/user/todos/TodoArchive.vue'

export default {
    components: { UserSideNav, UserTopNav, TodoActive, TodoArchive },
    data(){
        return {
            searchTerm: '',
        }
    },
    methods: {
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
        navigateToCreateTodo(){
            this.$router.push({ name: 'CreateTodo' })
        },
    },
    
}
</script>

<style>

</style>