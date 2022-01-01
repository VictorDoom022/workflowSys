<template>
    <div class="container-fluid">

        <Loading v-if="isLoading" />

        <div class="row mb-2">
            <div class="col-sm-4"></div>
            <div class="col-sm-4 pr-0">
                <p class="text-sm-end pt-1">Sort By: </p>
            </div>
            <div class="col-sm-4 pl-1">
                <select class="form-select form-select-sm" @change="sortList($event)">
                    <option v-for="sortOptions in selectSortOptions" :key="sortOptions" :value="sortOptions">
                        {{ sortOptions }}
                    </option>
                </select>
            </div> 
        </div>

        <b-row v-if="taskList.length && isCardView">
            <b-col md="6" v-for="task in searchTask" :key="task.id">
                <TaskItem :taskPageData="taskListPageData" :task="task" :userData="userData" :userDetailData="userDetailData" />
            </b-col> 
        </b-row>

        <b-row v-if="taskList.length && !isCardView">
            <div class="table-responsive" id="proTeamScroll" tabindex="2" style="overflow-x: auto; overflow-y: hidden; outline: none;">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th></th>
                            <th>Creator</th>
                            <th>Title</th>
                            <th>Priority</th>
                            <th>Last Updated</th>
                            <th>Status</th>
                            <th>Description</th>
                            <th>Users Invoved</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <TaskItemList 
                            v-for="task in searchTask" :key="task.id" 
                            :taskPageData="taskListPageData" 
                            :task="task" 
                            :userData="userData" 
                            :userDetailData="userDetailData" 
                        />
                    </tbody>
                </table>
            </div>
        </b-row>

        <h2 v-if="!taskList.length">No Task Yet</h2>
    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../Loading.vue'
import TaskItem from '../TaskItem.vue'
import TaskItemList from '../TaskItemList.vue'

export default {
    // taskListPageData contains - groupID, teamID, taskListID, userID
    props: ['isCardView', 'taskListPageData', 'searchTerm', 'userData', 'userDetailData'],
    components: { Loading, TaskItem, TaskItemList },
    data() {
        return {
            pageDataParsed: [],
            taskListUserID: null,
            groupID: null,
            teamID: null,
            taskListID: null,
            taskList: [],
            isLoading: true,
            selectSortOptions: ['Default', 'Create At Desc', 'Updated Asc', 'Updated Desc', 'Name Asc', 'Name Desc', 'Priority Asc', 'Priority Desc', 'Color Asc', 'Color Desc'],
        }
    },
    mounted() {
        this.pageDataParsed = JSON.parse(this.taskListPageData)
        this.taskListUserID = this.pageDataParsed.userID
        this.groupID = this.pageDataParsed.groupID
        this.teamID = this.pageDataParsed.teamID
        this.taskListID = this.pageDataParsed.taskListID
        this.fetchTaskListData()
    },
    methods: {
        fetchTaskListData(){
            Vue.axios({
                url: '/task/getTaskByTaskListID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    taskListID: this.taskListID,
                },
            }).then((response) => {
                this.taskList = response.data
                console.log(this.taskList)
                this.taskList.sort((a,b) => {
                    // return a.createAt.compareTo(b.createAt)
                    return new Date(a.updated_at) - new Date(b.updated_at)
                })
                this.isLoading = false
            })
        },
        sortList(event){
            console.log(event.target.value)
            if(this.selectSortOptions[0] == event.target.value){
                this.taskList.sort((a,b) => {
                    return new Date(a.created_at) - new Date(b.created_at)
                })
            }else if(this.selectSortOptions[1] == event.target.value){
                this.taskList.sort((a,b) => {
                    return new Date(b.created_at) - new Date(a.created_at)
                })
            }else if(this.selectSortOptions[2] == event.target.value){
                this.taskList.sort((a,b) => {
                    return new Date(a.updated_at) - new Date(b.updated_at)
                })
            }else if(this.selectSortOptions[3] == event.target.value){
                this.taskList.sort((a,b) => {
                    return new Date(b.updated_at) - new Date(a.updated_at)
                })
            }else if(this.selectSortOptions[4] == event.target.value){
                this.taskList.sort((a,b) => {
                    return a.task_name.localeCompare(b.task_name)
                })
            }else if(this.selectSortOptions[5] == event.target.value){
                this.taskList.sort((a,b) => {
                    return b.task_name.localeCompare(a.task_name)
                })
            }else if(this.selectSortOptions[6] == event.target.value){
                this.taskList.sort((a,b) => {
                    return a.task_priority - b.task_priority
                })
            }else if(this.selectSortOptions[7] == event.target.value){
                this.taskList.sort((a,b) => {
                    return b.task_priority - a.task_priority
                })
            }else if(this.selectSortOptions[8] == event.target.value){
                this.taskList.sort((a,b) => {
                    return a.task_color - b.task_color
                })
            }else if(this.selectSortOptions[9] == event.target.value){
                this.taskList.sort((a,b) => {
                    return b.task_color - a.task_color
                })
            }
        },
        navigateBack(){
            this.$router.go(-1)
        },
        searchFromNavBar(searchWordFromNavBar){
            this.searchTerm = searchWordFromNavBar
        },
    },
    computed: {
        searchTask(){
            return this.taskList.filter((task) => {
                if(this.searchTerm == ''){
                    return task.task_name
                }else{
                    return task.task_name.toLowerCase().includes(this.searchTerm.toLowerCase())
                }
            })
        }
    },
}
</script>

<style>

</style>