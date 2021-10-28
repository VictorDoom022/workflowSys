<script>
import { Line, mixins } from 'vue-chartjs'
// to show task being updated daily

// label = date
// data = count task for that day
export default {
    extends: Line,
    props: {
        data: {
            type: Array,
            default: null
        },
    },
    data(){
        return {
            chartdata: {
                labels: ['test', 'test2'],
                datasets: this.data
            },
            options: {
                responsive : true,
            }
        }
    },
    methods: {

    },
  mounted () {
    this.renderChart(this.chartdata, this.options)
  }
}
</script>