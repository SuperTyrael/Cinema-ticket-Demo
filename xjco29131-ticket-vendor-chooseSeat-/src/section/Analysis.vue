<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="cyan darken-1" dark>
          <v-card-title>Taking Yesterday</v-card-title>
          <v-card-subtitle>May 23th, 2021</v-card-subtitle>
          <v-card-text class="display-2">210</v-card-text>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="blue darken-1" dark>
          <v-card-title>Taking Yesterday</v-card-title>
          <v-card-subtitle>2nd Weak Of May, 2021</v-card-subtitle>
          <v-card-text class="display-2">14313</v-card-text>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="indigo darken-1" dark>
          <v-card-title>Taking Last Month</v-card-title>
          <v-card-subtitle>April 2021</v-card-subtitle>
          <v-card-text class="display-2">61290</v-card-text>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="purple darken-1" dark>
          <v-card-title>Taking Last Year</v-card-title>
          <v-card-subtitle>2020</v-card-subtitle>
          <v-card-text class="display-2">756482</v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card>
          <v-toolbar flat>
            <v-toolbar-title>Annual analysis</v-toolbar-title>
            <template v-slot:extension>
              <v-tabs
                  v-model="tab"
                  show-arrows
                  align-with-title
              >
                <v-tabs-slider color="primary"></v-tabs-slider>

                <v-tab
                    v-for="item in items"
                    :key="item"
                >
                  {{ item }}
                </v-tab>
              </v-tabs>
            </template>
          </v-toolbar>

          <div style="width:100%; height:300px"  id="sta_chart"></div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "Analysis",

  data: ()=>({
    chart_color:  ['#F44336', '#2196F3'],
    myChart:null,
    tab:0,
    items:[2019,2020,2021]
  }),


  computed:{
    years: function(){ return this.$store.state.years},
  },

  mounted() {
    let option = {
      legend: {},
      tooltip: {
        axisPointer: {
          type: 'cross'
        }
      },
      grid: {
        top: 70,
            bottom: 50
      },
      xAxis: [
        {
          type: 'category',
          axisTick: {
            alignWithLabel: true
          },
          axisLine: {
            onZero: false,
            lineStyle: {
              color: this.chart_color[1]
            }
          },
          axisPointer: {
            label: {}
          },
          data: this.years[0].weeks
        },
        {
          type: 'category',
          axisTick: {
            alignWithLabel: true
          },
          axisLine: {
            onZero: false,
            lineStyle: {
              color: this.chart_color[0]
            }
          },
          axisPointer: {
            label: {}
          },
          data: this.$store.state.months
        }
      ],
          yAxis: [
        {
          type: 'value'
        }
      ],
          series: [
        {
          name: 'Weekly taking',
          color: this.chart_color[1],
          type: 'line',
          xAxisIndex: 0,
          smooth: true,
          emphasis: {
            focus: 'series'
          },
          data: this.years[0].weeks_data
        },
        {
          name: 'Monthly taking',
          color: this.chart_color[0],
          type: 'line',
          xAxisIndex: 1,
          smooth: true,
          emphasis: {
            focus: 'series'
          },
          data: this.years[0].month_data
        }
      ]
    };
    this.myChart = this.$echarts.init(document.getElementById("sta_chart"));
    this.myChart.setOption(option)
  }
}
</script>

<style scoped>

</style>