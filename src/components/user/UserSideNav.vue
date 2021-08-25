<template>
  <nav class="sidebar d-flex">
      <div style="display: none">
        <svg id="appIcon" xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 0 24 24" width="24px" fill="#f8f9fa">
            <path d="M0 0h24v24H0z" fill="none"/><path d="M22 11V3h-7v3H9V3H2v8h7V8h2v10h4v3h7v-8h-7v3h-2V8h2v3z"/>
        </svg>
      </div>
      
      <div class="sidebar-item d-flex flex-column flex-shrink-0 p-3 text-white bg-dark">
        <a href="/" class="appTitleSection d-flex align-items-center mb-3 mb-md-0 mt-md-3 me-md-auto text-white text-decoration-none">
            <span class="nav-label fs-4">Workflow Sys</span>
            <svg class="appIcon pl-1 pt-1" width="40" height="32"><use xlink:href="#appIcon"/></svg>
        </a>

        <hr>

        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="#" class="nav-link active" aria-current="page">
                    <b-icon class="mr-1" icon="house-fill"></b-icon>
                    <span class="nav-label">Home</span>
                </a>
            </li>
            <li>
                <a href="#" class="nav-link text-white">
                    <b-icon class="mr-1" icon="list-check"></b-icon>
                    <span class="nav-label">To-do</span>
                </a>
            </li>
        </ul>
        
        <hr>

        <b-nav-item-dropdown right style="list-style: none;">
          <template #button-content>
            <em class="align-items-center text-white text-decoration-none">
                <img src="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png" alt="" width="32" height="32" class="rounded-circle me-2">
                <strong class="nav-label">{{ username }}</strong>
            </em>
          </template>
          <b-dropdown-item @click="logout">Sign Out</b-dropdown-item>
        </b-nav-item-dropdown>
      </div>
      <div class="b-example-divider"></div>
  </nav>
</template>

<script>
import Vue from 'vue'
import loggedInUserData from '../../functions/loggedInUserData'

export default {
    data() {
        return {
            username: '',
        }
    },
    methods: {
        logout(){
            Vue.axios({
                url: 'logout',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + loggedInUserData.state.userData['token'],
                    'Content-Type': 'application/json',
                },
            }).then((response) => {
                loggedInUserData.dispatch('createUserSession', null).then(() => {
                this.$router.push('/')
                })
            })
        },
    },
    mounted() {
      if(loggedInUserData.state.userData != null){
        this.username = loggedInUserData.state.userData['user'].name
      }else{
        this.$router.push('/')
      }
  }
}
</script>

<style scoped>
.sidebar {
    grid-area: sd;
}

main {
  display: flex;
  flex-wrap: nowrap;
  height: 100vh;
  height: -webkit-fill-available;
  max-height: 100vh;
  overflow-x: auto;
  overflow-y: hidden;
}

.b-example-divider {
  flex-shrink: 0;
  width: .1rem;
  height: 100vh;
  background-color: rgba(0, 0, 0, .1);
  border: solid rgba(0, 0, 0, .15);
  border-width: 1px 0;
  box-shadow: inset 0 .5em 1.5em rgba(0, 0, 0, .1), inset 0 .125em .5em rgba(0, 0, 0, .15);
}

.bi {
  text-align: center;
  vertical-align: -.125em;
  pointer-events: none;
  fill: currentColor;
}

.dropdown-toggle { outline: 0; }

.nav-flush .nav-link {
  border-radius: 0;
}

.scrollarea {
  overflow-y: auto;
}

.sidebar-item{
    width: 280px;
}

.fw-semibold { font-weight: 600; }
.lh-tight { line-height: 1.25; }


@media only screen and (max-width: 768px) {
    .appTitleSection{
        text-align: center;
        display: inline !important;
    }

    .nav-label{
        display:none;
    }

    .sidebar-item{
        width: 100px;
    }
}
</style>