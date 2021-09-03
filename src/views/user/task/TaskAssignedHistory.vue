<template>
    <div>
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Assign History
                        </h1>
                    </div>

                    <div class="container-fluid">
                        <table class="table table-bordered track_tbl">
                            <tr>
                                <th>Name</th>
                                <th>Date</th>
                            </tr>
                            <tr v-for="(assignedUser, index) in assigendUserListParsed" :key="'assignedUser' + index">
                                <td>{{ convertUserIDToName(assigendUserListParsed.split(',')[index]) }}</td>
                                <td>{{ convertDateTimeEpochToDateTime(assigendDateListParsed.split(',')[index]) }}</td>
                            </tr>
                        </table>
                    </div>
                </main>
            </div>
        </div>
    </div>
</template>

<script>
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'

export default {
    props: ['userList', 'assigendUserList', 'assigendDateList'],
    components: { UserSideNav, UserTopNav },
    data() {
        return {
            userListParsed: [],
            assigendUserListParsed: [],
            assigendDateListParsed: [],
        }
    },
    mounted(){
        this.userListParsed = JSON.parse(this.userList)
        this.assigendUserListParsed = JSON.parse(this.assigendUserList)
        this.assigendDateListParsed = JSON.parse(this.assigendDateList)
    },
    methods: {
        convertUserIDToName(userID){
            for(var i=0; i < this.userListParsed.length; i++){
                if(userID == this.userListParsed[i].id){
                    return this.userListParsed[i].name
                }
            }
        },
        convertDateTimeEpochToDateTime(epochDateTime){
            let convertedDateTime = new Date(1000*epochDateTime)
            // for some reason dont know why date,moth,year result will be a mess after converting to date format
            return convertedDateTime
        },
        navigateBack(){
            this.$router.go(-1)
        },
    },
}
</script>

<style>

</style>