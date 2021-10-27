<template>
  <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
    <div class="position-sticky pt-3">
      <ul class="nav flex-column">
        <li class="nav-item">
          <router-link :to="{ name: 'UserHome' }" class="nav-link" aria-current="page">
            <b-icon class="mr-1" icon="house-fill"></b-icon>
            Home
          </router-link>
        </li>
        <li class="nav-item">
          <router-link :to="{ name: 'UserGroup' }" class="nav-link">
            <b-icon class="mr-1" icon="people-fill"></b-icon>
            Groups
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
        <li class="nav-item">
          <router-link :to="{ name: 'Chat' }" class="nav-link">
            <b-icon class="mr-1" icon="chat-fill"></b-icon>  
            Chats 
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

<style lang="scss" scoped>
.sidebar {
	position: fixed;
	top: 0;
	bottom: 0;
	left: 0;
	z-index: 100;
	padding: 48px 0 0;
	box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
    
	.nav-link {
		font-weight: 500;
		color: white;

		.feather {
			margin-right: 4px;
			color: #727272;
		}

		&:hover {
			.feather {
				color: inherit;
			}
		}
	}

	.nav-link.router-link-active {
		color: #2470dc;
		.feather {
			color: inherit;
		}
	}
}

.sidebar-sticky {
	position: relative;
	top: 0;
	height: calc(100vh - 48px);
	padding-top: .5rem;
	overflow-x: hidden;
	overflow-y: auto;
}

.sidebar-heading {
	font-size: .75rem;
	text-transform: uppercase;
}

@media (max-width: 767.98px) {
	.sidebar {
		top: 5rem;
	}
}
</style>