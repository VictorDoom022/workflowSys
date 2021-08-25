<template>
    <div>
        <div class="d-flex justify-content-center mt-5">
            <div class="card">
                <div class="card-body">
                    <h1 class="card-title">Login</h1>
                    <b-alert variant="danger" v-if="error" show>{{ error }}</b-alert>
                    <form @submit.prevent="login">
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" v-model="email" class="form-control" autocomplete="on">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" v-model="password" class="form-control" autocomplete="current-password">
                        </div>

                        <div class="submit mb-3">
                            <button class="btn btn-primary">Login</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <Loading v-if="isLoading" />
    </div>
  
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../functions/loggedInUserData'
import Loading from '../components/Loading.vue'

export default {
    components: { Loading },
    data() {
        return {
            email: '',
            password: '',
            error: null,
            isLoading: false,
        }
    },
    methods: {
        login(){
            this.isLoading = true;
            Vue.axios.post(
                'login', {
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    email: this.email,
                    password: this.password,
                }
            ).then((response) => {
                this.isLoading = false;
                if(response.status == 201){
                    this.error = response.data['message'][0]
                }else{
                    this.error = null;
                    loggedInUserData.dispatch('createUserSession', response.data)
                    this.redirect()
                }
            })
        },
        redirect(){
            if(loggedInUserData.state.userData != null){
                if(loggedInUserData.state.userData['user'].position == 'admin'){
                    this.$router.push('adminHome')
                }else{
                    this.$router.push('userHome')
                }
            }
        }
    },
    mounted() {
        this.redirect()
    }
}
</script>

<style>

</style>