<template>
  <div @click="navigateToEditTask(task.id)" class="container card border-light shadow mb-2 border-end border-bottom border-top-0 border-start-0 my-1">
        <div class="row row-striped">
            <div class="col-lg-2 ">
                <p class="display-4 mb-0"><span class="badge badge-secondary">{{ convertDBDateToDate(task.updated_at) }}</span></p>
                <h4 class="mb-0 d-inline-block">{{ convertDBDateToMonthString(task.updated_at) }}</h4>
            </div>
            <div class="col-lg-10">
                <h3 class="text-start mb-0"><strong>{{ task.task_name }}</strong></h3>
                <ul class="list-inline text-start mb-1">
                    <li class="list-inline-item">
                        <b-icon class="mr-1" icon="person-plus-fill"></b-icon>
                        {{ convertUserIDToName(task.task_userCreateID) }}
                    </li>
                    <li class="list-inline-item">
                        <b-icon class="mr-1" icon="clock-history"></b-icon>
                            {{ convertDBDateToString(task.updated_at) }}
                    </li>
                    <li class="list-inline-item">
                        <b-icon class="mr-1" icon="person-lines-fill"></b-icon>
                        <span v-if="task.task_assignedMemberID">{{ getLastAssigendUser(task.task_assignedMemberID) }}</span>
                        <span v-if="!task.task_assignedMemberID">Not assigned</span>
                    </li>
                    <li class="list-inline-item">
                        <b-icon icon="info-circle"></b-icon>
                        {{ task.task_statusMsg }}
                    </li>
                </ul>
                <p class="text-start text-muted">{{ task.task_desc }}</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: ['teamID', 'task', 'userData', 'userDetailData'],
    methods: {
        convertDBDateToString(dbDate){
            let dateStr = new Date(dbDate)
            let dateToDisplay = dateStr.getFullYear() + '/' + dateStr.getMonth() + '/' + dateStr.getDate() + ' ' + dateStr.getHours() + ':' + dateStr.getMinutes()
            return dateToDisplay
        },
        convertDBDateToDate(dbDate){
            let dateStr = new Date(dbDate)
            return dateStr.getDate()
        },
        convertDBDateToMonthString(dbDate){
            let dateStr = new Date(dbDate)
            return dateStr.toLocaleDateString('default', { month: 'short' })
        },
        getLastAssigendUser(taskAssignUserList){
            var taskAssignUserListArr = taskAssignUserList.split(',')
            // get last element of array
            return this.convertUserIDToName(taskAssignUserListArr[taskAssignUserListArr.length-1])
        },
        convertUserIDToName(userID){
            for(var i=0; i < this.userData.length; i++){
                if(userID == this.userData[i].id){
                    return this.userData[i].name
                }
            }
        },
        navigateToEditTask(taskID){
            this.$router.push({ name: 'EditTask', params: { teamID: this.teamID, taskID: taskID } })
        }
    }
}
</script>

<style scoped>
.card{
  cursor: pointer;
  transition: .5s ease;
}

.card:hover{
  box-shadow: 0 1rem 3rem rgb(0 0 0 / 18%) !important;
  transition: .3s ease;
}

.card p{
    -webkit-line-clamp: 1; 
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-box-orient: vertical;
}

/* breakpoint lg */
@media screen and (max-width: 992px) {
    .card h3{
        margin: auto;
        text-align: unset !important;
    }

    .card ul{
        margin: auto;
        text-align: unset !important;
    }

    .card p{
        margin: auto;
        text-align: unset !important;
    }
}
</style>