<template>
  <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
      <ul class="nav flex-column">
        <li class="nav-item">
          <router-link :to="{ name: 'UserHome' }" class="nav-link" aria-current="page">
            <b-icon class="mr-1" icon="house-fill"></b-icon>
            Home
          </router-link>
        </li>
        <li class="nav-item">
          <router-link :to="{ name: 'TodoList' }" class="nav-link">
            <b-icon class="mr-1" icon="list-check"></b-icon>  
            Todo
          </router-link>
        </li>
        <li class="nav-item">
          <router-link :to="{ name: 'UserProfile' }" class="nav-link">
            <b-icon class="mr-1" icon="person-fill"></b-icon>  
            Profile 
          </router-link>
        </li>
      </ul>

      <h6 class="sidebar-heading d-flex justify-content-between align-items-center text-center px-3 mt-4 mb-1 text-muted">
        <span>Signed in as {{ username }}</span>
      </h6>

      <ul class="nav flex-column mb-2">
        <li class="nav-item">
          <a class="nav-link" href="#">
            <!-- To implement stuffs -->
          </a>
        </li>
      </ul>
    </div>
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
  position: fixed;
  top: 0;
  /* rtl:raw:
  right: 0;
  */
  bottom: 0;
  /* rtl:remove */
  left: 0;
  z-index: 100; /* Behind the navbar */
  padding: 48px 0 0; /* Height of navbar */
  box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
}

@media (max-width: 767.98px) {
  .sidebar {
    top: 5rem;
  }
}

.sidebar-sticky {
  position: relative;
  top: 0;
  height: calc(100vh - 48px);
  padding-top: .5rem;
  overflow-x: hidden;
  overflow-y: auto; /* Scrollable contents if viewport is shorter than content. */
}

.sidebar .nav-link {
  font-weight: 500;
  color: #333;
}

.sidebar .nav-link .feather {
  margin-right: 4px;
  color: #727272;
}

.sidebar .nav-link.router-link-active {
  color: #2470dc;
}

.sidebar .nav-link:hover .feather,
.sidebar .nav-link.router-link-active .feather {
  color: inherit;
}

.sidebar-heading {
  font-size: .75rem;
  text-transform: uppercase;
}
</style>