<template>
    <div>
        <main class="form-signin">
            <form @submit.prevent="login">
                <h1 class="title my-4">
                    <span class="title-orange">Task</span>
                    <span class="title-black">Kit</span>
                </h1>
                
                <h1 class="h3 mb-3 fw-normal">Welcome</h1>

                <b-alert variant="danger" v-if="error" show>{{ error }}</b-alert>

                <div class="form-floating">
                    <input type="email" v-model="email" class="form-control" placeholder="Email" autocomplete="on">
                    <label for="floatingInput">Email address</label>
                </div>

                <div class="form-floating">
                    <input type="password" v-model="password" class="form-control" placeholder="Password" autocomplete="current-password">
                    <label>Password</label>
                </div>

                <div class="submit">
                    <button class="w-100 btn btn-lg btn-primary">Login</button>
                </div>
            </form>

            <router-link :to="{ name: 'Register' }" class="register-btn mt-3" style="text-decoration:none; color: unset">
                Don't have an account? <span class="title-orange">Register</span>
            </router-link>
            
        </main>
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
                this.error = null;
                loggedInUserData.dispatch('createUserSession', response.data)
                this.redirect()
            }).catch((e) =>{
                this.isLoading = false;
                this.error = "Incorrect email or password."
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

<style lang="scss" scoped>
html {
	height: 100%;
}

body {
	height: 100%;
	display: flex;
	align-items: center;
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #f5f5f5;
}

.title {
	font-weight: bold;
	font-size: 50px;
}

.title-orange {
	color: #E46B10FF;
}

.btn-primary {
	background-image: linear-gradient(to right, #FBB448FF 0%, #F7892BFF 100%);
	border-color: transparent !important;
}

.form-signin {
	width: 100%;
	max-width: 330px;
	padding: 15px;
	margin: auto;

	.checkbox {
		font-weight: 400;
	}

	.form-floating {
		&:focus-within {
			z-index: 2;
		}
	}

	input[type="email"] {
		margin-bottom: -1px;
		border-bottom-right-radius: 0;
		border-bottom-left-radius: 0;
	}

	input[type="password"] {
		margin-bottom: 10px;
		border-top-left-radius: 0;
		border-top-right-radius: 0;
	}
}

.register-btn {
	&:hover {
		cursor: pointer;
		background: rgba(250, 225, 225, 0.8) !important;
	}
}
</style>