<template>
    <b-modal v-model="teamModalShown" id="modal-1" title="Teams">
        
        <input type="text" v-model="searchTerm" class="form-control" placeholder="Search team...">

        <div class="my-3" v-if="teamList.length">
            <div v-for="team in searchTeam" :key="team.id" @click="navigateToTaskListList(team.id)" class="card my-1">
                <div class="card-body">
                    <h5 class="card-title">{{ team.team_name }}</h5>
                </div>
            </div>
        </div>

        <div class="my-3" v-if="!teamList.length">
            <h2 class="text-center">No users</h2>
        </div>
    </b-modal>
</template>

<script>
export default {
    props: ['groupID','teamList', 'viewOnly'],
    data() {
        return {
            teamModalShown: true,
            searchTerm: '',
        }
    },
    watch: {
        teamModalShown: function(val) {
            this.$emit('teamModalShown', val)
        }
    },
    methods: {
        navigateToTaskListList(teamID){
            this.$router.push({ name: 'TaskListList', params: { groupID: this.groupID, teamID: teamID}})
        }
    },
    computed: {
      searchTeam(){
        return this.teamList.filter((team) => {
          if(this.searchTerm == ''){
            return team.team_name
          }else{
            return team.team_name.toLowerCase().includes(this.searchTerm.toLowerCase())
          }
        })
      }
    }
}
</script>

<style scoped>
.card:hover {
    cursor: pointer;
}
</style>