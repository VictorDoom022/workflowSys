<template>
    <b-modal v-model="modalShown" id="modal-1" title="Select member" @ok="okButtonClick">
        
        <input type="text" v-model="searchTerm" class="form-control" placeholder="Search member...">

        <div class="my-3">
            <div v-for="user in searchUser" :key="user.id" class="card my-1">
                <div class="card-body">
                    <h5 class="card-title">{{ user.name }}</h5>
                    <h6 class="card-subtitle mb-2 text-muted">{{ user.email }}</h6>
                </div>
            </div>
        </div>
    </b-modal>
</template>

<script>
export default {
    props: ['userList'],
    data() {
        return {
            modalShown: true,
            searchTerm: '',
        }
    },
    methods: {
        okButtonClick(){
            console.log('ok');
        }
    },
    computed: {
      searchUser(){
        return this.userList.filter((user) => {
          if(this.searchTerm == ''){
            return user.name
          }else{
            return user.name.toLowerCase().includes(this.searchTerm.toLowerCase()) || user.email.toLowerCase().includes(this.searchTerm.toLowerCase())
          }
        })
      }
    }
}
</script>

<style scoped>

</style>