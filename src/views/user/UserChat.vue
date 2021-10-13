<template>
    <div class="main">

    <UserTopNav />
    <div class="container-fluid">
      <div class="row">
        <UserSideNav />

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Chats</h1>
            </div>

            <div class="row g-0" style="height: 100%">
                <div class="col-md-4 px-0">
                    <UserChatList @selectedUser="selectUserFromUserList" style="height: 100%"/>
                </div>
                <div v-if="currentSelectedUserID!=''" class="col-md-8 px-0">
                    <ChatList :senderUserID="currentLoggedInUserID" :receiverUserID="currentSelectedUserID"/>
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
import ChatList from '../../components/user/chats/ChatList.vue'
import UserChatList from '../../components/user/chats/UserChatList.vue'
import loggedInUserData from '../../functions/loggedInUserData'

export default {
    components: { UserSideNav, UserTopNav, ChatList, UserChatList },
    data() { 
        return {
            currentSelectedUserID: '',
            currentLoggedInUserID: '',
        }
    },
    mounted() {
        this.currentLoggedInUserID = loggedInUserData.state.userData['user'].id
    },
    methods: {
        selectUserFromUserList(selectedUser){
            this.currentSelectedUserID = selectedUser
        }
    }
}
</script>

<style>

</style>