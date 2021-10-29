<template>
    <div>
        <Loading v-if="isLoading"/>

        <div v-if="!isLoading" id="sidepanel">
            <div id="profile">
                <div class="wrap">
                    <img id="profile-img" :src="'http://192.168.0.181:8000/' + currentLoggedInUserData['userDetail'].userDetail_profilePictureDir" class="online" alt="" />
                    <p>{{ currentLoggedInUserData['user'].name }}</p>
                    <i class="fa fa-chevron-down expand-button" aria-hidden="true"></i>
                    <div id="status-options">
                        <ul>
                            <li id="status-online" class="active"><span class="status-circle"></span> <p>Online</p></li>
                            <li id="status-away"><span class="status-circle"></span> <p>Away</p></li>
                            <li id="status-busy"><span class="status-circle"></span> <p>Busy</p></li>
                            <li id="status-offline"><span class="status-circle"></span> <p>Offline</p></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div id="search">
                <label class="mr-0"><b-icon icon="search"></b-icon> </label>
                <input type="text" placeholder="Search contacts..." />
            </div>
            <div id="contacts">
                <ul v-for="chat in chatData" :key="chat.id" style="list-style: none; padding-left: 0;">
                    <li @click="selectUser(chat.chat_receiverUserID)" class="contact">
                        <div class="wrap">
                            <span class="contact-status online"></span>
                            <img :src="'http://192.168.0.181:8000/' + convertUserIDToUserDetailData(chat.chat_receiverUserID).userDetail_profilePictureDir" alt="" />

                            <div class="meta">
                                <p class="name">{{ convertUserIDToUserData(chat.chat_receiverUserID).name }}</p>
                                <p class="preview">{{ convertUserIDToUserData(chat.chat_receiverUserID).email }}</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    
</template>

<script>
// for displaying user's chat history
import Vue from 'vue'
import loggedInUserData from '../../../functions/loggedInUserData'
import Loading from '../../Loading.vue'

export default {
    components: { Loading },
    data() {
        return {
            isLoading: true,
            chatData: null,
            userData: [],
            userDetailData: [],
            currentLoggedInUserData: '',
        }
    },
    mounted() {
        this.currentLoggedInUserData = loggedInUserData.state.userData
        this.fetchUserData()
    },
    methods: {
        getUserChat(){
            Vue.axios({
                url: '/chat/getUserChatHistory',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
                data: {
                    userID    : loggedInUserData.state.userData['user'].id,
                },
            }).then((response) => {
                this.chatData = response.data
                this.isLoading = false
            })
        },
        fetchUserData(){
            Vue.axios({
                url: '/users',
                method: 'GET',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                this.userData = response.data['user'];
                this.userDetailData = response.data['userDetail'];
                this.getUserChat()
            })
        },
        convertUserIDToUserData(userID){
            for(var i=0; i < this.userData.length; i++){
                if(userID == this.userData[i].id){
                    return this.userData[i]
                }
            }
        },
        convertUserIDToUserDetailData(userID){
            for(var i=0; i < this.userDetailData.length; i++){
                if(userID == this.userDetailData[i].id){
                    return this.userDetailData[i]
                }
            }
        },
        selectUser(userID){
          this.$emit('selectedUser', userID)
        }
    },

}
</script>

<style lang="scss" scoped>

$backgroundDark: #343a40;
$backgroundGrey: #6c757d;

#sidepanel {
	float: left;
	min-width: 280px;
	min-height: 500px;
	width: 100%;
	height: 100%;
	background: $backgroundDark;
	color: #f5f5f5;
	overflow: hidden;
	position: relative;

	#profile {
		width: 80%;
		margin: 10px auto;
		.wrap {
			height: 60px;
			line-height: 60px;
			overflow: hidden;
			-moz-transition: 0.3s height ease;
			-o-transition: 0.3s height ease;
			-webkit-transition: 0.3s height ease;
			transition: 0.3s height ease;

			img {
				width: 50px;
				max-height: 50px;
				border-radius: 50%;
				padding: 3px;
				border: 2px solid #e74c3c;
				height: auto;
				float: left;
				cursor: pointer;
				-moz-transition: 0.3s border ease;
				-o-transition: 0.3s border ease;
				-webkit-transition: 0.3s border ease;
				transition: 0.3s border ease;
			}

			img.online {
				border: 2px solid #2ecc71;
			}

			img.away {
				border: 2px solid #f1c40f;
			}

			img.busy {
				border: 2px solid #e74c3c;
			}

			img.offline {
				border: 2px solid #95a5a6;
			}

			p {
				float: left;
				margin-left: 15px;
			}

			i.expand-button {
				float: right;
				margin-top: 23px;
				font-size: 0.8em;
				cursor: pointer;
				color: #435f7a;
			}

			#status-options {
				position: absolute;
				opacity: 0;
				visibility: hidden;
				width: 150px;
				margin: 70px 0 0 0;
				border-radius: 6px;
				z-index: 99;
				line-height: initial;
				background: #435f7a;
				-moz-transition: 0.3s all ease;
				-o-transition: 0.3s all ease;
				-webkit-transition: 0.3s all ease;
				transition: 0.3s all ease;

				&:before {
					content: '';
					position: absolute;
					width: 0;
					height: 0;
					border-left: 6px solid transparent;
					border-right: 6px solid transparent;
					border-bottom: 8px solid #435f7a;
					margin: -8px 0 0 24px;
				}

				ul {
					overflow: hidden;
					border-radius: 6px;

					li {
						padding: 15px 0 30px 18px;
						display: block;
						cursor: pointer;

						&:hover {
							background: #496886;
						}

						span.status-circle {
							position: absolute;
							width: 10px;
							height: 10px;
							border-radius: 50%;
							margin: 5px 0 0 0;

							&:before {
								content: '';
								position: absolute;
								width: 14px;
								height: 14px;
								margin: -3px 0 0 -3px;
								background: transparent;
								border-radius: 50%;
								z-index: 0;
							}
						}

						p {
							padding-left: 12px;
						}
					}

					li#status-online {
						span.status-circle {
							background: #2ecc71;
						}
					}

					li#status-online.active {
						span.status-circle {
							&:before {
								border: 1px solid #2ecc71;
							}
						}
					}

					li#status-away {
						span.status-circle {
							background: #f1c40f;
						}
					}

					li#status-away.active {
						span.status-circle {
							&:before {
								border: 1px solid #f1c40f;
							}
						}
					}

					li#status-busy {
						span.status-circle {
							background: #e74c3c;
						}
					}

					li#status-busy.active {
						span.status-circle {
							&:before {
								border: 1px solid #e74c3c;
							}
						}
					}

					li#status-offline {
						span.status-circle {
							background: #95a5a6;
						}
					}

					li#status-offline.active {
						span.status-circle {
							&:before {
								border: 1px solid #95a5a6;
							}
						}
					}

				}
			}

			#status-options.active {
				opacity: 1;
				visibility: visible;
				margin: 75px 0 0 0;
			}

			#expanded {
				padding: 100px 0 0 0;
				display: block;
				line-height: initial !important;

				label {
					float: left;
					clear: both;
					margin: 0 8px 5px 0;
					padding: 5px 0;
				}

				input {
					border: none;
					margin-bottom: 6px;
					background: $backgroundDark;
					border-radius: 3px;
					color: #f5f5f5;
					padding: 7px;
					width: calc(100% - 43px);

					&:focus {
						outline: none;
						background: #435f7a;
					}
				}
			}
		}
	}

	#profile.expanded {
		.wrap {
			height: 210px;
			line-height: initial;

			p {
				margin-top: 20px;
			}

			i.expand-button {
				-moz-transform: scaleY(-1);
				-o-transform: scaleY(-1);
				-webkit-transform: scaleY(-1);
				transform: scaleY(-1);
				filter: FlipH;
				-ms-filter: "FlipH";
			}
		}
	}
  
	#search {
		border-top: 1px solid $backgroundDark;
		border-bottom: 1px solid $backgroundDark;
		font-weight: 300;

		label {
			position: absolute;
			margin: 5px 0 0 15px;
		}

		input {
			font-family: "proxima-nova", "Source Sans Pro", sans-serif;
			padding: 5px 0 5px 46px;
			width: calc(100% - 25px);
			border: none;
			background: $backgroundGrey;
			color: #f5f5f5;

			&:focus {
				outline: none;
				background: #435f7a;
			}

			&::-webkit-input-placeholder {
				color: #f5f5f5;
			}

			&::-moz-placeholder {
				color: #f5f5f5;
			}

			&:-ms-input-placeholder {
				color: #f5f5f5;
			}

			&:-moz-placeholder {
				color: #f5f5f5;
			}
		}
	}

	#contacts {
		height: calc(100% - 177px);
		overflow-y: scroll;
		overflow-x: hidden;

		&::-webkit-scrollbar {
			width: 8px;
			background: #2c3e50;
		}

		&::-webkit-scrollbar-thumb {
			background-color: #243140;
		}

		ul {
			li.contact {
				position: relative;
				padding: 10px 0 15px 0;
				font-size: 0.9em;
				cursor: pointer;

				&:hover {
					background: $backgroundGrey;
				}

				.wrap {
					width: 88%;
					margin: 0 auto;
					position: relative;

					span {
						position: absolute;
						left: 0;
						margin: -2px 0 0 -2px;
						width: 10px;
						height: 10px;
						border-radius: 50%;
						border: 2px solid #2c3e50;
						background: #95a5a6;
					}

					span.online {
						background: #2ecc71;
					}

					span.away {
						background: #f1c40f;
					}

					span.busy {
						background: #e74c3c;
					}

					img {
						width: 40px;
						max-height: 40px;
						border-radius: 50%;
						float: left;
						margin-right: 10px;
					}

					.meta {
						padding: 5px 0 0 0;

						.name {
							font-weight: 600;
							margin-bottom: 0px;
						}

						.preview {
							margin: 5px 0 0 0;
							padding: 0 0 1px;
							font-weight: 400;
							white-space: nowrap;
							overflow: hidden;
							text-overflow: ellipsis;
							-moz-transition: 1s all ease;
							-o-transition: 1s all ease;
							-webkit-transition: 1s all ease;
							transition: 1s all ease;

							span {
								position: initial;
								border-radius: initial;
								background: none;
								border: none;
								padding: 0 2px 0 0;
								margin: 0 0 0 1px;
								opacity: .5;
							}
						}
					}
				}
			}

			li.contact.active {
				background: #32465a;
				border-right: 5px solid #435f7a;

				span.contact-status {
					border: 2px solid #32465a !important;
				}
			}
		}
	}

	#contacts.expanded {
		height: calc(100% - 334px);
	}

	#bottom-bar {
		position: absolute;
		width: 100%;
		bottom: 0;

		button {
			float: left;
			border: none;
			width: 50%;
			padding: 10px 0;
			background: #32465a;
			color: #f5f5f5;
			cursor: pointer;
			font-size: 0.85em;
			font-family: "proxima-nova", "Source Sans Pro", sans-serif;

			&:focus {
				outline: none;
			}

			&:nth-child(1) {
				border-right: 1px solid #2c3e50;
			}

			&:hover {
				background: #435f7a;
			}

			i {
				margin-right: 3px;
				font-size: 1em;
			}
		}
	}
}

@media screen and (max-width: 735px) {
	#sidepanel {
		width: 100%;
		min-width: 58px;

		#profile {
			width: 100%;
			margin: 0 auto;
			padding: 5px 0 0 0;
			background: $backgroundDark;

			.wrap {
				height: 55px;

				img {
					width: 40px;
					margin-left: 4px;
				}

				p {
					display: none;
				}

				i.expand-button {
					display: none;
				}

				#status-options {
					width: 58px;
					margin-top: 57px;

					&:before {
						margin-left: 23px;
					}

					ul {
						li {
							padding: 15px 0 35px 22px;
							span.status-circle {
								width: 14px;
								height: 14px;
								&:before {
									height: 18px;
									width: 18px;
								}
							}

							p {
								display: none;
							}
						}
					}
				}

				#status-options.active {
					margin-top: 62px;
				}
			}
		}

		#search {
			display: none;
		}

		#contacts {
			height: calc(100% - 149px);
			overflow-y: scroll;
			overflow-x: hidden;

			&::-webkit-scrollbar {
				display: none;
			}

			ul {
				li.contact {
					.wrap {
						width: 100%;
						img {
							margin-right: 0px;
						}

						.meta {
							.preview {
								display: none;
							}
						}
					}
				}
			}
		}

		#bottom-bar {
			button {
				float: none;
				width: 100%;
				padding: 15px 0;
				&:nth-child(1) {
					border-right: none;
					border-bottom: 1px solid #2c3e50;
				}

				i {
					font-size: 1.3em;
				}
        
				span {
					display: none;
				}
			}
		}
	}
}
</style>