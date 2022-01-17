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
                    <div class="col px-1">
                        <div class="card bg-darkBlue rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-white">Total Tasks</h5>
                                <p class="card-text text-white fs-3">{{ totalTaskCount }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col px-1">
                        <div class="card bg-lightGreen rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-white">Active Tasks</h5>
                                <p class="card-text text-white fs-3">{{ activeTaskCount }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col px-1">
                        <div class="card bg-lightOrange rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-white">Tasks Assigned</h5>
                                <p class="card-text text-white fs-3">{{ assignedToUserTaskCount }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col px-1">
                        <div class="card bg-pink rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-white">High Priority Tasks</h5>
                                <p class="card-text text-white fs-3">{{ highPriorityTaskCount }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col px-1">
                        <div class="card bg-blue rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold text-white">Completed Task</h5>
                                <p class="card-text text-white fs-3">{{ completedTaskCount }}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-12 px-1">
                        <div class="card rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold">Task Complete Percentage</h5>
                                <b-progress :max="totalTaskCount">
                                    <b-progress-bar variant="success" :value="completedTaskCount" :label="`${((completedTaskCount / totalTaskCount) * 100).toFixed(2)}%`" animated show-progress></b-progress-bar>
                                    <b-progress-bar variant="primary" :value="activeTaskCount"></b-progress-bar>
                                </b-progress>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-6 px-1">
                        <div class="card rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold">Recent Task Activity</h5>
                                <DrawBarChart
                                    v-if="!isLoading"
                                    :chartdata="recentTaskActivityChartData"
                                />
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 px-1 mb-3">
                        <div class="card rounded-0">
                            <div class="card-body">
                                <h5 class="card-title fw-bold">Completed Task History</h5>
                                <DrawBarChart
                                    v-if="!isLoading"
                                    :chartdata="completedTaskHistoryChartData"
                                />
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
import DrawBarChart from './DrawBarChart.vue'

export default {
    components: { UserSideNav, UserTopNav, DrawBarChart },
    data() {
        return {
            isLoading: true,
            taskOverViewData: [],
            totalTaskCount: 0,
            activeTaskCount: 0,
            completedTaskCount: 0,
            highPriorityTaskCount: 0,
            assigendToUserTaskCount: 0,
            taskRecentActivityData: [],
            completedTaskHistoryData: [],
            recentTaskActivityChartData: null,
            completedTaskHistoryChartData: null,
        }
    },
    mounted() {
        this.fetchTaskOverviewData()
    },
    methods: {
        fetchTaskOverviewData(){
            Vue.axios({
                url: '/data/getUserTaskOverview',
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
                this.taskOverViewData = response.data
                this.setOverViewData()
                this.setRecentTaskChartData()
                this.setTaskHistoryChartData()
            })
        },
        setOverViewData(){
            this.totalTaskCount = this.taskOverViewData['totalTask']
            this.activeTaskCount = this.taskOverViewData['activeTaskCount']
            this.completedTaskCount = this.taskOverViewData['completedTaskCount']
            this.highPriorityTaskCount = this.taskOverViewData['highPriorityTaskCount']
            this.assignedToUserTaskCount = this.taskOverViewData['assignedToUserTaskCount']
            this.taskRecentActivityData = this.taskOverViewData['recentTaskActivityData']
            this.completedTaskHistoryData = this.taskOverViewData['completedTaskHistoryData']
            this.isLoading = false
        },
        setRecentTaskChartData(){
            var labelArray = []
            var dataArray = []

            for(var i = 0;i < this.taskRecentActivityData.length; i++){
                labelArray.push(this.taskRecentActivityData[i].date)
                dataArray.push(this.taskRecentActivityData[i].taskCount)
            }

            this.recentTaskActivityChartData = {
                labels: labelArray,
                datasets: [
                    {
                        label: ['Task Count'],
                        data: dataArray,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                    }
                ]
            };
        },
        setTaskHistoryChartData(){
            var labelArray = []
            var dataArray = []

            for(var i = 0;i < this.completedTaskHistoryData.length; i++){
                labelArray.push(this.completedTaskHistoryData[i].date)
                dataArray.push(this.completedTaskHistoryData[i].taskCount)
            }

            this.completedTaskHistoryChartData = {
                labels: labelArray,
                datasets: [
                    {
                        label: ['Task Count'],
                        data: dataArray,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                    }
                ]
            };
        }
    }
}
</script>

<style scoped>
.card:hover{
    background-color: rgba(175, 175, 175, 0.5);
    transition: .5s ease;
}

.bg-darkBlue{
    background-color:#4f4fae;
}

.bg-lightGreen{
    background-color: #2ed694;
}

.bg-lightOrange{
    background-color:#fe6f5e;
}

.bg-pink{
    background-color: #ff3f78;
}

.bg-blue{
    background-color: #475afe;
}

</style>