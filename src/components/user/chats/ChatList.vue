<template>
    <div>
        <Loading v-if="isLoading" />

        <div v-if="!isLoading" class="content">
            <div class="contact-profile">
                <img :src="'http://192.168.0.181:8000/' + receiverUserDetailData.userDetail_profilePictureDir" alt="" />
                <p>{{ receiverUserData.name }}</p>
            </div>
            <div v-if="chatData" class="messages">
                <ul v-for="chat in chatData" :key="chat.id">
                    <li v-if="chat.chat_receiverUserID != currentLoggedInUserID" class="replies">
                        <img :src="'http://192.168.0.181:8000/' + senderUserDetailData.userDetail_profilePictureDir" alt="" />
                        <p>{{ chat.chat_message }}</p>
                    </li>
                    <li v-if="chat.chat_receiverUserID == currentLoggedInUserID" class="sent">
                        <img :src="'http://192.168.0.181:8000/' + receiverUserDetailData.userDetail_profilePictureDir" alt="" />
                        <p>{{ chat.chat_message }}</p>
                    </li>
                </ul>
            </div>

            <div v-if="!chatData.length">
                <p>No chat history</p>
            </div>
            <div class="message-input">
                <div class="wrap">
                    <input v-model="chatMessage" @keyup.enter="sendMessage()" type="text" placeholder="Write your message..." />
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
            senderUserData: [],
            senderUserDetailData: [],
            receiverUserData: [],
            receiverUserDetailData: [],
            chatData: [],
            chatMessage: '',
            currentLoggedInUserID: '',
        }
    },
    mounted() {
        this.currentLoggedInUserID = loggedInUserData.state.userData['user'].id
        this.getSenderUserDetails()
    },
    watch: {
      immediate: true,
      receiverUserID: function(newUserID, oldUserID) {
        this.getChatData()
      }
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
                this.getReceiverUserDetails()
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
                this.getChatData()
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
                this.getChatData()
            })
        },
    }
}
</script>

<style lang="scss" scoped>

$backgroundDark: #343a40;

.content {
	float: right;
	width: 100%;
	height: 100%;
	overflow: hidden;

	.contact-profile {
		width: 100%;
		height: 60px;
		line-height: 60px;
		background: #f5f5f5;

		img {
			width: 40px;
			max-height: 40px;
			border-radius: 50%;
			float: left;
			margin: 9px 12px 0 9px;
		}

		p {
			float: left;
		}

		.social-media {
			float: right;

			i {
				margin-left: 14px;
				cursor: pointer;
                
				&:nth-last-child(1) {
					margin-right: 20px;
				}

				&:hover {
					color: #435f7a;
				}
			}
		}
	}
	.messages {
		width: 100%;
		height: auto;
		min-height: calc(100% - 93px);
		max-height: calc(100% - 93px);
		overflow-y: scroll;
		overflow-x: hidden;

		&::-webkit-scrollbar {
			width: 8px;
			background: transparent;
		}

		&::-webkit-scrollbar-thumb {
			background-color: rgba(0, 0, 0, 0.3);
		}

		ul {
			li {
				display: inline-block;
				clear: both;
				float: left;
				margin: 15px 15px 5px 15px;
				width: calc(100% - 25px);
				font-size: 0.9em;

				&:nth-last-child(1) {
					margin-bottom: 20px;
				}

				img {
					width: 22px;
					border-radius: 50%;
					float: left;
					object-fit:cover;
    				object-position:50% 50%;
				}

				p {
					display: inline-block;
					padding: 10px 15px;
					border-radius: 20px;
					max-width: 205px;
					line-height: 130%;
				}
			}

			li.sent {

				img {
					margin: 6px 8px 0 0;
				}

				p {
					float: left;
					background: $backgroundDark;
					color: #f5f5f5;
				}
			}
			li.replies {

				img {
					float: right;
					margin: 6px 0 0 8px;
				}

				p {
					background: #f5f5f5;
					float: right;
				}
			}
		}
	}

	.message-input {
		position: absolute;
		bottom: 0;
		width: 100%;
		z-index: 99;

		.wrap {
			position: relative;

			input {
				font-family: "proxima-nova", "Source Sans Pro", sans-serif;
				float: left;
				border: none;
				width: calc(100% - 90px);
				padding: 11px 32px 10px 8px;
				font-size: 0.8em;
				color: $backgroundDark;
				&:focus {
					outline: none;
				}
			}

			.attachment {
				position: absolute;
				right: 60px;
				z-index: 4;
				margin-top: 10px;
				font-size: 1.1em;
				color: #435f7a;
				opacity: .5;
				cursor: pointer;
				&:hover {
					opacity: 1;
				}
			}

			button {
				float: right;
				border: none;
				width: 50px;
				padding: 12px 0;
				cursor: pointer;
				background: $backgroundDark;
				color: #f5f5f5;
				&:hover {
					background: #435f7a;
				}
				&:focus {
					outline: none;
				}
			}
		}
	}
}

@media screen and (max-width: 735px) {
	.content {
		min-width: 300px !important;

		.messages {
			max-height: calc(100% - 105px);
		}

		.message-input {
			.wrap {
				input {
					padding: 15px 32px 16px 8px;
				}

				.attachment {
					margin-top: 17px;
					right: 65px;
				}

				button {
					padding: 16px 0;
				}
			}
		}
	}
}

@media screen and (min-width: 735px) {
	.content {
		.messages {
			ul {
				li {
					p {
						max-width: 300px;
					}
				}
			}
		}
	}
}
</style>