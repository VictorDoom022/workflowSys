<template>
    <div class="comment">
        <a class="comment-img" href="#non">
            <img :src="'http://192.168.0.181:8000/' + getUserProfilePictureDir(commentData.comment_userID)" alt="" width="50" height="50">
        </a>
        <div class="comment-body">
            <div class="text">
                <p>{{ commentData.comment_details }}</p>
            </div>
            <p class="attribution">
                by <a @click="navigateToUserInfo(commentData.comment_userID)" class="userLink">{{ convertUserIDToName(commentData.comment_userID) }}</a> 
                at {{ convertDBDateToString(commentData.created_at) }}
            </p>
        </div>
    </div>
</template>

<script>
export default {
    props: ['commentData', 'userData', 'userDetailData'],
    methods: {
        convertUserIDToName(userID){
            for(var i=0; i < this.userData.length; i++){
                if(userID == this.userData[i].id){
                    return this.userData[i].name
                }
            }
        },
        navigateToUserInfo(userID){
            this.$router.push({ name: 'UserInfo', params: { userID: userID }})
        },
        getUserProfilePictureDir(userID){
            for(var i=0; i < this.userData.length; i++){
                if(userID == this.userData[i].id){
                    return this.userDetailData[i].userDetail_profilePictureDir
                }
            }
        },
        convertDBDateToString(dbDate){
            let dateStr = new Date(dbDate)
            let dateToDisplay = dateStr.getFullYear() + '/' + dateStr.getMonth() + '/' + dateStr.getDate() + ' ' + dateStr.getHours() + ':' + dateStr.getMinutes()
            return dateToDisplay
        },
    },
}
</script>

<style lang="scss" scoped>
/* Decoration */
.comment {
	overflow: hidden;
	padding: 0 0 1em;
	*zoom: 1;
	position: relative;

	.text {
		padding: 10px;
		border: 1px solid #e5e5e5;
		border-radius: 5px;
		background: #fff;

		p {
			&:last-child {
				margin: 0;
			}
		}

		&:before {
			content: "";
			position: absolute;
			top: 0;
			left: 65px;
			top: 18px;
			left: 78px;
			width: 9px;
			height: 9px;
			border-width: 0 0 1px 1px;
			border-style: solid;
			border-color: #e5e5e5;
			background: #fff;
			-webkit-transform: rotate(45deg);
			-moz-transform: rotate(45deg);
			-ms-transform: rotate(45deg);
			-o-transform: rotate(45deg);
		}
	}

	.attribution {
        text-align: left;
		margin: 0.5em 0 0;
		font-size: 14px;
		color: #666;

        .userLink {
            cursor: pointer;
        }
	}

	&:before {
		content: "";
		position: absolute;
		top: 0;
		left: 65px;
		width: 9px;
		height: 9px;
		border: 3px solid #fff;
		border-radius: 100px;
		margin: 16px 0 0 -6px;
		box-shadow: 0 1px 1px rgba(0,0,0,0.2), inset 0 1px 1px rgba(0,0,0,0.1);
		background: #ccc;
	}

	&:hover {
		&:before {
			background: orange;
		}
	}
}

.comment-img {
	float: left;
	margin-right: 33px;
	border-radius: 5px;
	overflow: hidden;

	img {
		display: block;
	}
}

.comment-body {
	overflow: hidden;
}

.comments {
	position: relative;

	&:before {
		content: "";
		position: absolute;
		top: 0;
		left: 65px;
		width: 3px;
		top: -20px;
		bottom: -20px;
		background: rgba(0,0,0,0.1);
	}
}
</style>