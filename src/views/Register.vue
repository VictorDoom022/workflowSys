<template>
    <div>
        <main class="form-signin">
            <form @submit.prevent="register">
                <h1 class="title my-4">
                    <span class="title-orange">Task</span>
                    <span class="title-black">IT</span>
                </h1>
                
                <h1 class="h3 mb-3 fw-normal">Register</h1>

                <b-alert variant="danger" v-if="error" show>{{ error }}</b-alert>

                <div class="form-floating">
                    <input type="text" v-model="name" class="form-control remove-bottom-border" placeholder="Name" autocomplete="off">
                    <label>Name</label>
                </div>

                <div class="form-floating">
                    <input type="email" v-model="email" class="form-control" style="border-radius: 0;" placeholder="Email" autocomplete="on">
                    <label for="floatingInput">Email address</label>
                </div>

                <div class="form-floating">
                    <input type="password" v-model="password" class="form-control" style="border-radius: 0;" placeholder="Password" autocomplete="current-password">
                    <label>Password</label>
                </div>

                <div class="form-floating">
                    <input type="password" v-model="confirm_password" class="form-control remove-top-border" placeholder="Password" autocomplete="current-password">
                    <label>Confirm Password</label>
                </div>

                <div class="submit">
                    <button class="w-100 btn btn-lg btn-primary">Register</button>
                </div>
            </form>

            <router-link :to="{ name: 'Login' }" class="login-btn mt-3" style="text-decoration:none; color: unset">
                Already have an an account? <span class="title-orange">Login</span>
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
            name: '',
            email: '',
            password: '',
            confirm_password: '',
            error: null,
            isLoading: false,
        }
    },
    methods: {
        register(){
            if(this.name != '' || this.email != '' || this.password != '' || this.confirm_password != ''){
                this.isLoading = true;
                Vue.axios.post(
                    '/register', {
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        name: this.name,
                        email: this.email,
                        password: this.password,
                        password_confirmation: this.confirm_password,
                    }
                ).then((response) => {
                    this.isLoading = false;
                    console.log(response);
                    if(response.status == 200){
                        this.error = null;
                        loggedInUserData.dispatch('createUserSession', response.data)
                        this.redirect()
                    }
                }).catch((e) => {
                    this.isLoading = false;
                    this.error = "Invalid input";
                })
            }else{
                this.error = "Please fill in all required fields.";
            }
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
}

.remove-top-border {
	margin-bottom: 10px;
	border-top-left-radius: 0;
	border-top-right-radius: 0;
}

.remove-bottom-border {
	border-bottom-left-radius: 0;
	border-bottom-right-radius: 0;
}

.login-btn {
	&:hover {
		cursor: pointer;
		background: rgba(250, 225, 225, 0.8) !important;
	}
}

</style>