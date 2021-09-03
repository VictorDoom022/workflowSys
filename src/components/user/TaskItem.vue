<template>
  <div class="container card my-1">
        <div class="row row-striped">
            <div class="col-2 text-right">
                <p class="display-4"><span class="badge badge-secondary">23</span></p>
                <h2>OCT</h2>
            </div>
            <div class="col-10">
                <h3><strong>{{ task.task_name }}</strong></h3>
                <ul class="list-inline">
                    <li class="list-inline-item"><i class="fa fa-calendar-o" aria-hidden="true"></i> Monday</li>
                    <li class="list-inline-item"><i class="fa fa-clock-o" aria-hidden="true"></i> 12:30 PM - 2:00 PM</li>
                    <li class="list-inline-item"><i class="fa fa-location-arrow" aria-hidden="true"></i> Cafe</li>
                </ul>
                <p>{{ task.task_desc }}</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: ['task']
}
</script>

<style>

</style>