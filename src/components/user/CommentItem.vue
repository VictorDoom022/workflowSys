<template>
    <div class="row mb-2">
        <div class="col-2 px-2">
            <img class="thumb-lg member-thumb round-circle" :src="'http://192.168.0.181:8000/' + getUserProfilePictureDir(commentData.comment_userID)">
        </div>
        <div class="col-10 px-1">
            <div class="card px-2">
                <h5 class="card-title text-start fw-bold">
                    <a @click="navigateToUserInfo(commentData.comment_userID)" class="userLink">{{ convertUserIDToName(commentData.comment_userID) }}</a> 
                </h5>
                <div class="card-text text-start">
                    {{ commentData.comment_details }}

                    <p class="text-muted mb-1">
                        {{ convertDBDateToString(commentData.created_at) }}
                    </p>
                </div>
            </div>
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

<style scoped>
.userLink {
    cursor:pointer;
    color: #212529;
}

.thumb-lg {
    height: 58px;
    width: 58px;
}

.img-thumbnail {
    padding: .25rem;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: .25rem;
    max-width: 100%;
    height: auto;
}
</style>