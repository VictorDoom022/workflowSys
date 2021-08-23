<template>
  <div class="d-flex justify-content-center">
    <div class="card">
        <div class="card-body">
            <h1 class="card-title">Login</h1>
            <b-alert variant="danger" v-if="error" show>{{ error }}</b-alert>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" v-model="email" class="form-control">
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" v-model="password" class="form-control">
            </div>

            <div class="mb-3">
                <button class="btn btn-primary" @click="login">Login</button>
            </div>

            {{ token }} - {{ user }}
        </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
    data() {
        return {
            email: '',
            password: '',
            user: [],
            userDetail: [],
            token: '',
            error: null,
        }
    },
    methods: {
        login(){
            Vue.axios.post(
                'login', {
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    email: this.email,
                    password: this.password,
                }
            ).then((response) => {
                if(response.status == 201){
                    this.error = response.data['message'][0]
                }else{
                    this.user = response.data['user']
                    this.userDetail = response.data['userDetail']
                    this.token = response.data['token']
                }
            })

            // to store into local storage
        }
    }
}
</script>

<style>

</style>