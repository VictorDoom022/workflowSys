<template>
    <tr @click="navigateToEditTask(task.id)" style="cursor:pointer;">
        <td :class="colorClassName[task.task_color]"></td>
        <td class="table-img"><img :src="'http://192.168.0.181:8000/' + getUserProfilePicture(task.task_userCreateID)" alt="">
        <td>
            <h6 class="mb-0 font-13">{{ task.task_name }}</h6>
            <p v-if="task.task_assignedMemberID" class="m-0 font-12">
                Assigned to
                <span class="col-green font-weight-bold">{{ getLastAssigendUser(task.task_assignedMemberID) }}</span>
            </p>
        </td>
        <td v-bind:class="taskPriorityClassName[task.task_priority]">{{ convertPriorityTypeToString(task.task_priority) }}</td>
        <td>{{ convertDBDateToString(task.updated_at) }}</td>
        <td>{{ task.task_statusMsg }}</td>
        <td>{{ task.task_desc.slice(0,20) + '...' }}</td>
        <td class="text-truncate">
            <ul v-if="usersInvolvedList.length != 0" class="list-unstyled order-list m-b-0">
                <li v-for="(user, index) in usersInvolvedList.slice(0, 3)" :key="index" class="team-member team-member-sm">
                    <img class="rounded-circle" :src="'http://192.168.0.181:8000/' + user.userDetail_profilePictureDir" alt="user" data-toggle="tooltip" title="" data-original-title="John Deo">
                </li>
                <li v-if="usersInvolvedList.length > 3" class="avatar avatar-sm"><span class="badge badge-primary">+{{  usersInvolvedList.length - 3 }}</span></li>
            </ul>
            <p v-if="usersInvolvedList.length ==0">
                No users are involved
            </p>
        </td>
        <td>
            <a data-toggle="tooltip" title="" data-original-title="Edit"><i class="fas fa-pencil-alt"></i></a>
            <a data-toggle="tooltip" title="" data-original-title="Delete"><i class="far fa-trash-alt"></i></a>
        </td>
    </tr>
</template>

<script>
export default {
    // taskPageData contains - groupID, teamID, taskListID
    props: ['taskPageData', 'task', 'userData', 'userDetailData'],
    data() {
        return {
            usersInvolvedList: [],
            taskPriorityClassName : [
                'bg-light',
                'bg-secondary text-white',
                'bg-primary text-white',
                'bg-warning text-white',
                'bg-danger text-white'
            ],
            colorClassName : [
                'default', 
                'bg-primary', 
                'bg-danger', 
                'bg-warning', 
                'bg-success', 
                'bg-secondary', 
                'bg-dark'
            ]
        }
    },
    mounted() {
        this.generateUserInvolvedList()
    },
    methods: {
        generateUserInvolvedList(){
            let assignedMemberIDList = this.task.task_assignedMemberID.split(',')
            for(var i = 0; i < this.userDetailData.length; i++){
                for(var j = 0; j < assignedMemberIDList.length; j++){
                    if(this.userDetailData[i].id == assignedMemberIDList[j]){
                        this.usersInvolvedList.push(this.userDetailData[i])
                    }
                }
            }
        },
        convertColorTypeToClassName(colorID) {
            let colorClassArray = ['default', 'bg-primary text-white', 'bg-danger text-white', 'bg-warning text-white', 'bg-success text-white', ' bg-secondary text-white', 'bg-dark text-white']
            return colorClassArray[colorID]
        },
        convertPriorityTypeToString(priorityID){
            let priorityStringArray = ['Very Low', 'Low', 'Medium', 'High', 'Very High']
            return priorityStringArray[priorityID]
        },
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
        getUserProfilePicture(userID){
            for(var i=0; i < this.userDetailData.length; i++){
                if(userID == this.userDetailData[i].id){
                    return this.userDetailData[i].userDetail_profilePictureDir
                }
            }
        },
        navigateToEditTask(taskID){
            var pageDataParsed = JSON.parse(this.taskPageData)
            var jsonPageData = {
                taskListUserID: pageDataParsed.userID,
                groupID: pageDataParsed.groupID,
                teamID: pageDataParsed.teamID,
                taskListID: pageDataParsed.taskListID,
                taskID: taskID,
            }
            this.$router.push({ name: 'EditTask', params: { taskPageData: JSON.stringify(jsonPageData) } })
        }
    }
}
</script>

<style lang="scss" scoped>
.table {
	&:not(.table-sm) {
		thead {
			th {
				border-bottom: none;
				background-color: #e9e9eb;
				color: #666;
				padding-top: 15px;
				padding-bottom: 15px;
			}
		}
	}

	.table-img {
		img {
			width: 35px;
			height: 35px;
			border-radius: 50%;
			border: 2px solid #bbbbbb;
			-webkit-box-shadow: 5px 6px 15px 0px rgba(49,47,49,0.5);
			-moz-box-shadow: 5px 6px 15px 0px rgba(49,47,49,0.5);
			-ms-box-shadow: 5px 6px 15px 0px rgba(49,47,49,0.5);
			box-shadow: 5px 6px 15px 0px rgba(49,47,49,0.5);
			text-shadow: 0 0 black;
		}
	}

	.team-member-sm {
		width: 32px;
		-webkit-transition: all 0.25s ease;
		-o-transition: all 0.25s ease;
		-moz-transition: all 0.25s ease;
		transition: all 0.25s ease;
	}

	.team-member {
		position: relative;
		width: 30px;
		white-space: nowrap;
		border-radius: 1000px;
		vertical-align: bottom;
		display: inline-block;
		img {
			width: 100%;
			max-width: 100%;
			height: auto;
			border: 0;
			border-radius: 1000px;
		}
	}

	.order-list {
		li {
			img {
				border: 2px solid #ffffff;
				box-shadow: 4px 3px 6px 0 rgba(0,0,0,0.2);
                max-width: 30px;
                max-height: 32px;
                min-width: 30px;
                min-height: 32px;
			}
			.badge {
				background: rgba(228,222,222,0.8);
				color: #6b6f82;
				margin-bottom: 6px;
			}
		}
		li+li {
			margin-left: -14px;
			background: transparent;
		}
	}
}

.rounded-circle {
	border-radius: 50% !important;
}

.avatar.avatar-sm {
	font-size: 12px;
	height: 30px;
	width: 30px;
}

.avatar {
	background: #6777ef;
	border-radius: 50%;
	color: #e3eaef;
	display: inline-block;
	font-size: 16px;
	font-weight: 300;
	margin: 0;
	position: relative;
	vertical-align: middle;
	line-height: 1.28;
	height: 45px;
	width: 45px;
}

.badge {
    vertical-align: middle;
    padding: 7px 12px;
    font-weight: 600;
    letter-spacing: 0.3px;
    border-radius: 30px;
    font-size: 12px;
}

.progress-bar {
    display: -ms-flexbox;
    display: -webkit-box;
    display: flex;
    -ms-flex-direction: column;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    flex-direction: column;
    -ms-flex-pack: center;
    -webkit-box-pack: center;
    justify-content: center;
    overflow: hidden;
    color: #fff;
    text-align: center;
    white-space: nowrap;
    background-color: #007bff;
    -webkit-transition: width .6s ease;
    transition: width .6s ease;
}

.bg-success {
    background-color: #54ca68 !important;
}

.bg-purple {
    background-color: #9c27b0 !important;
    color: #fff;
}

.bg-cyan {
    background-color: #10cfbd !important;
    color: #fff;
}

.bg-red {
    background-color: #f44336 !important;
    color: #fff;
}

.progress {
    -webkit-box-shadow: 0 0.4rem 0.6rem rgba(0,0,0,0.15);
    box-shadow: 0 0.4rem 0.6rem rgba(0,0,0,0.15);
}
</style>