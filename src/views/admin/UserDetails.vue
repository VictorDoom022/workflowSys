<template>
    <div>
        <AdminTopNav />
        <div class="text-start mt-3 mx-2">
            <b-button variant="outline-dark" @click="navigateBack">back</b-button>
        </div>

        <div v-if="user == null" class="mx-auto">
            <div class="spinner-border text-dark" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>

        <b-container v-if="user != null">
            <div class="card mt-3 px-5 justify-content-md-center">
                <table class="table table-striped table-hover mt-2">
                    <thead class="table-dark">
                        <tr>
                            <th class="text-end">Type</th>
                            <td class="text-start">Info</td>
                        </tr>
                    </thead>
                    <tr>
                        <th class="text-end">Name</th>
                        <td class="text-start">{{ user.name }}</td>
                    </tr>
                    <tr>
                        <th class="text-end">Email</th>
                        <td class="text-start">{{ user.email }}</td>
                    </tr>
                    <tr>
                        <th class="text-end">Create at</th>
                        <td class="text-start">{{ user.created_at }}</td>
                    </tr>
                    <tr>
                        <th class="text-end">Account Status</th>
                        <td class="text-start">{{ userDetail.userDetail_status }}</td>
                    </tr>
                    <tr>
                        <th class="text-end">Account enabled</th>
                        <td class="text-start text-success" v-if=" userDetail.userDetail_accEnable == 1">
                            Enabled
                        </td>
                        <td class="text-start text-danger" v-if=" userDetail.userDetail_accEnable == 0">
                            Banned
                        </td>
                    </tr>
                </table>
            </div>
        </b-container>
        
    </div>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../functions/loggedInUserData'
import AdminTopNav from '../../components/admin/AdminTopNav.vue'

export default {
    props: ['userID'],
    components: { AdminTopNav },
    data() {
        return {
            user: null,
            userDetail: null,
        }
    },
    mounted() {
        Vue.axios({
            url: 'http://localhost:8000/api/users/'+  this.userID,
            method: 'GET',
            headers: {
                Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                'Content-Type': 'application/json',
            },
        }).then((response) => {
            this.user = response.data['user']
            this.userDetail = response.data['userDetail']
        })
    },
    methods: {
        navigateBack(){
            this.$router.go(-1)
        }
    }
}
</script>

<style>

</style>