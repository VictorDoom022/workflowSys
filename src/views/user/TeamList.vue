<template>
    <div>
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Group ({{ groupDetail.group_name }})</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button type="button" class="btn btn-sm btn-primary mx-1">Settings</button>
                            <button type="button" class="btn btn-sm btn-success mx-1">Create Team</button>
                        </div>
                    </div>

                    <div class="container-fluid">
                        <b-row>
                            <b-col md="12" class="mb-3">
                                <input type="text" v-model="searchTerm" class="form-control" placeholder="Search team...">
                            </b-col>

                            <b-col md="4" v-for="team in teamList" :key="team.id">
                                <div class="card border-dark mb-2" style="text-align:left; min-height:100px">
                                    <div class="card-body">
                                        <h4 class="card-title text-center">{{ team.team_name }}</h4>
                                    </div>
                                </div>
                            </b-col> 

                        </b-row>
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
    props: ['groupID'],
    components: { UserSideNav, UserTopNav },
    data() {
        return {
            groupDetail: [],
            teamList: [],
        }
    },
    mounted() {
        this.getGroupDetail()
    },
    methods: {
        getGroupDetail(){
            Vue.axios({
                url: '/group/getGroupDetailByGroupUserID',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    groupID: this.groupID,
                    userID: loggedInUserData.state.userData['user'].id,
                },
            }).then((response) => {
                this.groupDetail = response.data['group']
                this.teamList = response.data['team']
            })
        },
    }
}
</script>

<style>

</style>