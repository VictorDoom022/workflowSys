<template>
    <div>
        <AdminTopNav />
        {{ userID }}
    </div>
</template>

<script>
import AdminTopNav from '../../components/admin/AdminTopNav.vue'

export default {
    props: ['userID'],
    components: { AdminTopNav },
}
</script>

<style>

</style>