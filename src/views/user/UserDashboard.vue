<template>
  <div class="main">

    <UserTopNav />
    <div class="container-fluid">
      <div class="row">
        <UserSideNav />

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Dashboard</h1>
            </div>

            <div v-if="isLoading" class="mx-auto">
              <div class="spinner-border text-dark" role="status" style="width: 3rem; height: 3rem;">
                  <span class="visually-hidden">Loading...</span>
              </div>
            </div>

            <div v-if="!isLoading" class="contaier-fluid">
                <div class="row g-1">
                    <div class="col-lg-4 px-1">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-success">Active Tasks</h5>
                                <p class="card-text fs-3">{{ userActiveTask.length }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 px-1">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-danger">High Priority Tasks</h5>
                                <p class="card-text fs-3">{{ userHighPriorityTask.length }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 px-1">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-primary">Assigend To You</h5>
                                <p class="card-text fs-3">{{ taskAssignUser.length }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../components/user/UserSideNav.vue'
import UserTopNav from '../../components/user/UserTopNav.vue'
import loggedInUserData from '../../functions/loggedInUserData'

export default {
    components: { UserSideNav, UserTopNav },
    data() {
        return {
            isLoading: true,
            userActiveTask: [],
            userHighPriorityTask: [],
            taskAssignUser: [],
        }
    },
    mounted() {
        this.fetchUserActiveTask()
    },
    methods: {
        fetchUserActiveTask(){
            Vue.axios({
                url: '/data/getUserActiveTask',
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                params: {
                    userID: loggedInUserData.state.userData['user'].id,
                },
            }
            ).then((response) => {
                this.userActiveTask = response.data
                this.fetchUserHighPriorityTask()
            })
        },
        fetchUserHighPriorityTask(){
            Vue.axios({
                url: '/data/getHighPriorityTask',
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                params: {
                    userID: loggedInUserData.state.userData['user'].id,
                },
            }
            ).then((response) => {
                this.userHighPriorityTask = response.data
                this.fetchTaskAssigendToUser()
            })
        },
        fetchTaskAssigendToUser(){
            Vue.axios({
                url: '/data/getAssigendToUserTask',
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                params: {
                    userID: loggedInUserData.state.userData['user'].id,
                },
            }
            ).then((response) => {
                this.taskAssignUser = response.data
                this.isLoading = false
            })
        }
    }
}
</script>

<style>

</style>