<template>
    <div>
        <UserTopNav/>
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <span @click="navigateBack()" style="cursor:pointer">
                                <b-icon class="mr-1" icon="caret-left-fill"></b-icon>
                            </span>
                            Create Task
                        </h1>
                    </div>

                    <div class="container-fluid">
                        
                    </div>
                </main>
            </div>
        </div>
    </div>
</template>

<script>
import UserSideNav from '../../../components/user/UserSideNav.vue'
import UserTopNav from '../../../components/user/UserTopNav.vue'

export default {
    components: { UserSideNav, UserTopNav },
    methods: {
        navigateBack(){
            this.$router.go(-1)
        },
    },
}
</script>

<style>

</style>