<template>
  <div @click="navigateToEditTodo(todo.id)" class="container card my-1">
        <div class="row row-striped">
            <div class="col-lg-2 ">
                <p class="display-4 mb-0"><span class="badge badge-secondary">{{ convertDBDateToDate(todo.updated_at) }}</span></p>
                <h4 class="mb-0">{{ convertDBDateToMonthString(todo.updated_at) }}</h4>
            </div>
            <div class="col-lg-10">
                <h3 class="text-start mb-0"><strong>{{ todo.todo_name }}</strong></h3>
                <ul class="list-inline text-start mb-1">
                    <li class="list-inline-item">
                        <b-icon class="mr-1" icon="clock-history"></b-icon>
                            {{ convertDBDateToString(todo.updated_at) }}
                    </li>
                    <li class="list-inline-item">
                        <b-icon icon="info-circle"></b-icon>
                        {{ todo.todo_statusMsg }}
                    </li>
                </ul>
                <p class="text-start">{{ todo.todo_desc }}</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: ['todo'],
    methods: {
        convertDBDateToString(dbDate){
            let dateStr = new Date(dbDate)
            let dateToDisplay = dateStr.getFullYear() + '/' + dateStr.getMonth() + '/' + dateStr.getDate() + ' ' + dateStr.getHours() + ':' + dateStr.getMinutes()
            return dateToDisplay
        },
        convertDBDateToDate(dbDate){
            let dateStr = new Date(dbDate)
            return dateStr.getDate()
        },
        convertDBDateToMonthString(dbDate){
            let dateStr = new Date(dbDate)
            return dateStr.toLocaleDateString('default', { month: 'short' })
        },
        navigateToEditTodo(todoID){
            this.$router.push({ name: 'EditTodo', params: { todoID: todoID }})
        }
    }
}
</script>

<style scoped>
.card {
    cursor: pointer;
}
</style>