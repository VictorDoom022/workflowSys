<script>
import { Bar, mixins } from 'vue-chartjs'

export default {
    extends: Bar,
    props: {
        chartdata: {
            type: Object,
            default: null
        },
    },
    data(){
        return {
            options: {
                responsive : true,
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                },
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