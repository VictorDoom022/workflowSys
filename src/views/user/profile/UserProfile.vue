<template>
    <div class="main">
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <Loading v-if="isLoading"/>

                <main v-if="!isLoading" class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Profile</h1>
                    </div>

                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <img :src="'http://192.168.0.181:8000/' + userDetail.userDetail_profilePictureDir" class="rounded-circle img-thumbnail mb-4" style="height: 200px; width: 200px" alt="profile-image">
                                <h2>{{ user.name }}</h2>
                                <p class="text-muted">{{ user.email }}</p>
                                <form @submit.prevent="uploadProfilePicture">
                                    <label class="form-label">Change Profile Picture</label>
                                    <div class="d-flex">
                                        <input class="form-control form-control-sm"  type="file" accept="image/*" @change="onFileChange">
                                        <button class="btn btn-primary btn-sm ml-1" :disabled="!fileData">Change</button>
                                    </div>
                                </form>
                            </div>
                            <div class="col-md-8">
                                <div class="row">
                                    <div class="col-lg-6 mb-1 px-1">
                                        <div class="card rounded-0" style="min-height: calc(100vh -25%);">
                                            <div class="card-body text-center py-5 fs-4">
                                                <p class="mb-0">Account Status</p>
                                                <p class=" fs-5 fw-bold" :class="userDetail.userDetail_accEnable == 1 ? 'text-success' : 'text-danger'">
                                                    {{ userDetail.userDetail_accEnable == 1 ? 'Enabled' : 'Banned' }}
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-6 mb-1 px-1">
                                        <div class="card rounded-0" style="min-height: calc(100vh -25%);">
                                            <div class="card-body text-center py-5 fs-4">
                                                <p class="mb-0">Account Created At</p>
                                                <p class="text-primary fs-5 fw-bold">{{ convertDBDateToString(user.created_at) }}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-12 mb-1 px-1">
                                        <div class="card rounded-0" style="min-height: calc(100vh -25%);">
                                            <div class="card-body text-center py-5 fs-4">
                                                <p class="mb-0">Group(s) Joined</p>
                                                <p class="text-info fs-5 fw-bold">{{ countJoinedGroup(userDetail.userDetail_joinedGroupID) }}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid" style="display:none">
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

                                        <div class="col-md-6" style="margin-left: auto; margin-right: auto">
                                            <form @submit.prevent="uploadProfilePicture">
                                                <label class="form-label">Change Profile Picture</label>
                                                <div class="d-flex">
                                                    <input class="form-control form-control-sm"  type="file" accept="image/*" @change="onFileChange">
                                                    <button class="btn btn-primary btn-sm ml-1" :disabled="!fileData">Change</button>
                                                </div>
                                            </form>
                                        </div>
                                        
                                        <div class="mt-4">
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
    components: { UserSideNav, UserTopNav, Loading },
    data() {
        return {
            isLoading: true,
            user: null,
            userDetail: null,
            fileData: '',
        }
    },
    mounted() {
        this.getUserDetails()
    },
    methods: {
        getUserDetails() {
            Vue.axios({
                url: '/users/'+  loggedInUserData.state.userData['user'].id,
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
        onFileChange(e){
            this.fileData = e.target.files[0]
        },
        uploadProfilePicture(){
            this.isLoading = true
            let formData = new FormData()
            formData.append('profilePicture', this.fileData)
            formData.append('userID', loggedInUserData.state.userData['user'].id)

            Vue.axios.post(
                '/users/uploadProfilePicture', 
                formData ,
                {
                    headers: {
                        Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                        'Content-Type': 'multipart/form-data'
                    },
                }
            ).then((response) => {
                this.getUserDetails()
                this.toastMessage(response)
            })
        },
        toastMessage(response) {
            Vue.swal.fire({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                icon: response.status == 200 ? 'success' : 'error',
                title: response.data['message']
            })
        },
    },
}
</script>

<style scoped>
.card:hover{
    background-color: #f8f9fa;
    transition: .5s ease;
}

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