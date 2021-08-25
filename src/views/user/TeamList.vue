<template>
    <div>
        <UserTopNav />
        <div class="container-fluid">
            <div class="row">
                <UserSideNav />

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Group (Name)</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <button type="button" class="btn btn-sm btn-primary mx-1">Settings</button>
                            <button type="button" class="btn btn-sm btn-success mx-1">Create Team</button>
                        </div>
                    </div>
                </main>

            </div>
        </div>
    </div>
</template>

<script>
import Vue from 'vue'
import UserSideNav from '../../components/user/UserSideNav.vue'
import UserTopNav from '../../components/user/UserTopNav.vue'

export default {
    props: ['groupID'],
    components: { UserSideNav, UserTopNav },
}
</script>

<style>

</style>