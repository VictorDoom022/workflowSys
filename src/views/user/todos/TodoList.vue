<template>
    <div>
        <UserTopNav showSearchBar="true" @searchWord="searchFromNavBar" />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            Todo List
                        </h1>

                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="col-sm-7 pr-0">
                                <div class="row">
                                    <div class="col-sm-5 pr-1">
                                        <p class="text-sm-end pt-1">Sort By: </p>
                                    </div>
                                    <div class="col-sm-7 pl-1">
                                        <select class="form-select form-select-sm" @change="selectedSortType = $event">
                                            <option v-for="sortOptions in selectSortOptions" :key="sortOptions" :value="sortOptions">
                                                {{ sortOptions }}
                                            </option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-5 pl-1">
                                <button @click="navigateToCreateTodo()" type="button" class="btn btn-sm btn-primary mx-1">Create Todo</button>    
                            </div> 
                        </div>
                    </div>

                    <b-tabs content-class="mt-3" align="center" fill>
                        <b-tab title="Active" active>
                            <TodoActive :selectedSortType="selectedSortType" :searchTerm="searchTerm" />
                        </b-tab>
                        <b-tab title="Archive">
                            <TodoArchive :selectedSortType="selectedSortType" :searchTerm="searchTerm" />
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
            selectSortOptions: ['Default', 'Name Desc', 'Updated Asc', 'Updated Desc', 'Created At Asc', 'Create At Desc'],
            selectedSortType: [],
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