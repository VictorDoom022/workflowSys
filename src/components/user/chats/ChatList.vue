<template>
    <div>
        <Loading v-if="isLoading" />

        <div v-if="!isLoading" class="content">
            <div class="contact-profile">
                <img :src="'http://192.168.0.181:8000/' + receiverUserDetailData.userDetail_profilePictureDir" alt="" />
                <p>{{ receiverUserData.name }}</p>
            </div>
            <div class="messages">
                <ul>
                    <li class="sent">
                        <img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />
                        <p>How the hell am I supposed to get a jury to believe you when I am not even sure that I do?!</p>
                    </li>
                    <li class="replies">
                        <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                        <p>When you're backed against the wall, break the god damn thing down.</p>
                    </li>
                    <li class="replies">
                        <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                        <p>Excuses don't win championships.</p>
                    </li>
                    <li class="sent">
                        <img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />
                        <p>Oh yeah, did Michael Jordan tell you that?</p>
                    </li>
                    <li class="replies">
                        <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                        <p>No, I told him that.</p>
                    </li>
                    <li class="replies">
                        <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                        <p>What are your choices when someone puts a gun to your head?</p>
                    </li>
                    <li class="sent">
                        <img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />
                        <p>What are you talking about? You do what they say or they shoot you.</p>
                    </li>
                    <li class="replies">
                        <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                        <p>Wrong. You take the gun, or you pull out a bigger one. Or, you call their bluff. Or, you do any one of a hundred and forty six other things.</p>
                    </li>
                </ul>
            </div>
            <div class="message-input">
                <div class="wrap">
                    <input v-model="chatMessage" type="text" placeholder="Write your message..." />
                    <i class="fa fa-paperclip attachment" aria-hidden="true"></i>
                    <button @click="sendMessage()" class="submit"><b-icon class="mr-1" icon="play-fill"></b-icon></button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
// for displaying user's chat data
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../Loading.vue'

export default {
    props: ['senderUserID', 'receiverUserID'],
    components: { Loading },
    data() {
        return {
            isLoading: true,
            senderUserData: null,
            senderUserDetailData: null,
            receiverUserData: null,
            receiverUserDetailData: null,
            chatData: null,
            chatMessage: '',
        }
    },
    mounted() {
        this.getSenderUserDetails()
        this.getReceiverUserDetails()
        this.getChatData()
    },
    methods: {
        getChatData(){
            Vue.axios({
                url: '/chat/getUserChat',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    senderUserID    : loggedInUserData.state.userData['user'].id,
                    receiverUserID  :  this.receiverUserID,
                },
            }).then((response) => {
                this.isLoading = false
                this.chatData = response.data
            })
        },
        getSenderUserDetails() {
            Vue.axios({
                url: '/users/'+ this.senderUserID,
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.isLoading = false
                this.senderUserData = response.data['user']
                this.senderUserDetailData = response.data['userDetail']
            })
        },
        getReceiverUserDetails() {
            Vue.axios({
                url: '/users/'+ this.receiverUserID,
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.isLoading = false
                this.receiverUserData = response.data['user']
                this.receiverUserDetailData = response.data['userDetail']
            })
        },
        sendMessage(){
            Vue.axios({
                url: '/chat/sendMessage',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    senderUserID    : loggedInUserData.state.userData['user'].id,
                    receiverUserID  : this.receiverUserID,
                    chatMessage     : this.chatMessage,
                },
            }).then((response) => {
                this.chatMessage = ''
            })
        },
    }
}
</script>

<style scoped>
.content {
  float: right;
  width: 100%;
  height: 100%;
  overflow: hidden;
  position: relative;
}
@media screen and (max-width: 735px) {
  .content {
    /* width: calc(100% - 58px); */
    min-width: 300px !important;
  }
}
@media screen and (min-width: 900px) {
  .content {
    /* width: calc(100% - 340px); */
  }
}
.content .contact-profile {
  width: 100%;
  height: 60px;
  line-height: 60px;
  background: #f5f5f5;
}
.content .contact-profile img {
  width: 40px;
  border-radius: 50%;
  float: left;
  margin: 9px 12px 0 9px;
}
.content .contact-profile p {
  float: left;
}
.content .contact-profile .social-media {
  float: right;
}
.content .contact-profile .social-media i {
  margin-left: 14px;
  cursor: pointer;
}
.content .contact-profile .social-media i:nth-last-child(1) {
  margin-right: 20px;
}
.content .contact-profile .social-media i:hover {
  color: #435f7a;
}
.content .messages {
  width: 100%;
  height: auto;
  min-height: calc(100% - 93px);
  max-height: calc(100% - 93px);
  overflow-y: scroll;
  overflow-x: hidden;
}
@media screen and (max-width: 735px) {
  .content .messages {
    max-height: calc(100% - 105px);
  }
}
.content .messages::-webkit-scrollbar {
  width: 8px;
  background: transparent;
}
.content .messages::-webkit-scrollbar-thumb {
  background-color: rgba(0, 0, 0, 0.3);
}
.content .messages ul li {
  display: inline-block;
  clear: both;
  float: left;
  margin: 15px 15px 5px 15px;
  width: calc(100% - 25px);
  font-size: 0.9em;
}
.content .messages ul li:nth-last-child(1) {
  margin-bottom: 20px;
}
.content .messages ul li.sent img {
  margin: 6px 8px 0 0;
}
.content .messages ul li.sent p {
    float: left;

  background: #435f7a;
  color: #f5f5f5;
}
.content .messages ul li.replies img {
  float: right;
  margin: 6px 0 0 8px;
}
.content .messages ul li.replies p {
  background: #f5f5f5;
  float: right;
}
.content .messages ul li img {
  width: 22px;
  border-radius: 50%;
  float: left;
}
.content .messages ul li p {
  display: inline-block;
  padding: 10px 15px;
  border-radius: 20px;
  max-width: 205px;
  line-height: 130%;
}
@media screen and (min-width: 735px) {
  .content .messages ul li p {
    max-width: 300px;
  }
}
.content .message-input {
  position: absolute;
  bottom: 0;
  width: 100%;
  z-index: 99;
}
.content .message-input .wrap {
  position: relative;
}
.content .message-input .wrap input {
  font-family: "proxima-nova",  "Source Sans Pro", sans-serif;
  float: left;
  border: none;
  width: calc(100% - 90px);
  padding: 11px 32px 10px 8px;
  font-size: 0.8em;
  color: #32465a;
}
@media screen and (max-width: 735px) {
  .content .message-input .wrap input {
    padding: 15px 32px 16px 8px;
  }
}
.content .message-input .wrap input:focus {
  outline: none;
}
.content .message-input .wrap .attachment {
  position: absolute;
  right: 60px;
  z-index: 4;
  margin-top: 10px;
  font-size: 1.1em;
  color: #435f7a;
  opacity: .5;
  cursor: pointer;
}
@media screen and (max-width: 735px) {
  .content .message-input .wrap .attachment {
    margin-top: 17px;
    right: 65px;
  }
}
.content .message-input .wrap .attachment:hover {
  opacity: 1;
}
.content .message-input .wrap button {
  float: right;
  border: none;
  width: 50px;
  padding: 12px 0;
  cursor: pointer;
  background: #32465a;
  color: #f5f5f5;
}
@media screen and (max-width: 735px) {
  .content .message-input .wrap button {
    padding: 16px 0;
  }
}
.content .message-input .wrap button:hover {
  background: #435f7a;
}
.content .message-input .wrap button:focus {
  outline: none;
}
</style>