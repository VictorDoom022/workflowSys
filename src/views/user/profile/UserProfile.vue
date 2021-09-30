<template>
    <div class="main">
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Profile</h1>
                    </div>

                    <div class="container-fluid">
                        <form @submit.prevent="uploadProfilePicture">
                            <input type="file" accept="image/*" @change="onFileChange">

                            <button class="btn btn-primary">Submit</button>
                        </form>
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
import loggedInUserData from '../../../functions/loggedInUserData'

export default {
    components: { UserSideNav, UserTopNav },
    data() {
        return {
            fileData: '',
        }
    },
    methods: {
        onFileChange(e){
            this.fileData = e.target.files[0]
            console.log(e.target.files[0])
        },
        uploadProfilePicture(){
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

<style>

</style>