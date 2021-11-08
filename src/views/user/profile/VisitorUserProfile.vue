<template>
    <div class="main">
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="isLoading"/>

                <main v-if="!isLoading" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            {{ user.name }}'s Profile
                        </h1>
                    </div>

                    <div class="container-fluid">
                            <div class="justify-content-center align-items-center">
                                <div class="text-center card-box">
                                    <div class="member-card pt-2 pb-2">
                                        <div class="thumb-lg member-thumb mx-auto">
                                            <img :src="'http://192.168.0.181:8000/' + userDetail.userDetail_profilePictureDir" class="rounded-circle img-thumbnail" style="height: 90px; width: 90px" alt="profile-image">
                                        </div>
                                        
                                        <div class="mt-2">
                                            <h4>{{ user.name }}</h4>
                                            <p class="text-muted">{{ user.email }}</p>
                                        </div>
                                        
                                        <div class="mt-4">
                                            <button @click="navigateToChatList()" class="btn btn-md btn-success">
                                                Chat <b-icon class="mr-1" icon="chat"></b-icon>
                                            </button>

                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="mt-3">
                                                        <h4>{{ userDetail.userDetail_accEnable == 1 ? 'Enabled' : 'Banned' }}</h4>
                                                        <p class="mb-0 text-muted">Account Activation Status</p>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="mt-3">
                                                        <h4>{{ convertDBDateToString(user.created_at) }}</h4>
                                                        <p class="mb-0 text-muted">Account Created At</p>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="mt-3">
                                                        <h4>{{ countJoinedGroup(userDetail.userDetail_joinedGroupID) }}</h4>
                                                        <p class="mb-0 text-muted">Group(s) Joined</p>
                                                    </div>
                                                </div>
                                            </div>
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
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'
import Loading from '../../../components/Loading.vue'
import loggedInUserData from '../../../functions/loggedInUserData'

export default {
    props: ['userID'],
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            isLoading: true,
            user: null,
            userDetail: null,
        }
    },
    mounted() {
        this.getUserDetails()
    },
    methods: {
        getUserDetails() {
            Vue.axios({
                url: '/users/'+  this.userID,
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.isLoading = false
                this.user = response.data['user']
                this.userDetail = response.data['userDetail']
            })
        },
        convertDBDateToString(dbDate){
            let dateStr = new Date(dbDate)
            let dateToDisplay = dateStr.getFullYear() + '/' + dateStr.getMonth() + '/' + dateStr.getDate() + ' ' + dateStr.getHours() + ':' + dateStr.getMinutes()
            return dateToDisplay
        },
        countJoinedGroup(joinedGroupID){
            if(joinedGroupID.length != 0){
                let joinedGroupIDArray = joinedGroupID.split(',')
                return joinedGroupIDArray.length
            }else{
                return 0
            }
        },
        navigateToChatList(){
            this.$router.push({ name: 'ChatList', params: { senderUserID:  loggedInUserData.state.userData['user'].id, receiverUserID: this.userID }})
        },
        navigateBack(){
            this.$router.go(-1)
        },
    },
}
</script>

<style scoped>
.card-box {
    padding: 20px;
    border-radius: 3px;
    margin-bottom: 30px;
    background-color: #fff;
}

.thumb-lg {
    height: 88px;
    width: 88px;
}

.img-thumbnail {
    padding: .25rem;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: .25rem;
    max-width: 100%;
    height: auto;
    object-fit:cover;
    object-position:50% 50%;
}

.text-muted {
    color: #98a6ad!important;
}

h4 {
    line-height: 22px;
    font-size: 18px;
}
</style>