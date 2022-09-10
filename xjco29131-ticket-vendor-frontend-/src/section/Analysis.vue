<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="cyan darken-1" dark>
          <v-card-title>Movie Taking Yesterday</v-card-title>
          <v-card-subtitle>May 23th, 2021</v-card-subtitle>
          <v-card-text class="display-2">210</v-card-text>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="blue darken-1" dark>
          <v-card-title>Movie Taking Last Week</v-card-title>
          <v-card-subtitle>2nd Weak Of May, 2021</v-card-subtitle>
          <v-card-text class="display-2">14313</v-card-text>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="indigo darken-1" dark>
          <v-card-title>Movie Taking Last Month</v-card-title>
          <v-card-subtitle>April 2021</v-card-subtitle>
          <v-card-text class="display-2">61290</v-card-text>
        </v-card>
      </v-col>
      <v-col>
        <v-card color="purple darken-1" dark>
          <v-card-title>Movie Taking Last Year</v-card-title>
          <v-card-subtitle>2020</v-card-subtitle>
          <v-card-text class="display-2">756482</v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="10">
        <v-card class="pa-2">
          <v-card-title>Daily Analysis</v-card-title>
          <v-row class="ma-1">
            <v-col>
              <v-card flat outlined>
                <v-card-title dark class="overline" style="font-size: 1rem !important">Categories Analysis</v-card-title>
                <v-sheet height="200" id="pie_chart_1"></v-sheet>
              </v-card>
            </v-col>
            <v-col>
              <v-card flat outlined>
                <v-card-title dark class="overline" style="font-size: 1rem !important">Movie Takings Analysis</v-card-title>
                <v-sheet height="200" id="pie_chart_2"></v-sheet>
              </v-card>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
      <v-col cols="2">
        <v-hover
            v-slot="{ hover }"
            >
          <v-card height="100%" to="/Analysis/Comparison" color="primary" dark :elevation="hover ? 12 : 2">
            <v-card-title>Movie<br/> Comparison</v-card-title>
            <div style="width: 100%; text-align: center">  <v-icon class="display-4">mdi-compare</v-icon></div>
            <div style="height: 30px; width: 30px"></div>
            <div style="width: 100%; text-align: center; font-weight: bold; font-size: 2rem">Click To </div>
            <div style="width: 100%; text-align: center; font-weight: bold; font-size: 2rem">Start</div>
          </v-card>
        </v-hover>

      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-card >
          <v-card-title>Fuzzy Search Status</v-card-title>
          <v-container>
            <v-row>
              <v-col><v-card color="#5c8987" dark>
                <v-card-title>Response</v-card-title>
                <v-card-subtitle>2021/4/30</v-card-subtitle>
                <v-card-text class="display-1">50ms</v-card-text>
              </v-card></v-col>

              <v-col><v-card color="#b0b7ac" dark>
                <v-card-title>Number Of Items</v-card-title>
                <v-card-subtitle>Since 2021/4/12 8:00:34</v-card-subtitle>
                <v-card-text class="display-1">12379123</v-card-text>
              </v-card></v-col>

              <v-col><v-card color="#546b83" dark>
                <v-card-title>Running Time</v-card-title>
                <v-card-subtitle>Since 2021/4/12 8:00:34</v-card-subtitle>
                <v-card-text class="display-1">17 days, 6 hours</v-card-text>
              </v-card></v-col>


          </v-row>
          </v-container>
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
    pie_chart_1:null,
    pie_chart_2:null,
    tab:0,
    items:[2020]
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

    let pie_option_1 = {
      tooltip: {
        trigger: 'item'
      },
      legend: {
        orient: 'vertical',
        left: 'left',
      },
      series: [
        {
          center: ['70%', '50%'],
          name: 'Movie Categories',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: false,
            position: 'center'
          },
          labelLine: {
            show: false
          },
          data: [
            {value: 45, name: 'Action'},
            {value: 54, name: 'Animation'},
            {value: 64, name: 'Comic'},
            {value: 55, name: 'Plot'},
            {value: 27, name: 'Comedy'},
            {value: 35, name: 'Others'}
          ]
        }
      ]
    };
    this.pie_chart_1 = this.$echarts.init(document.getElementById("pie_chart_1"));
    this.pie_chart_1.setOption(pie_option_1)





    let pie_option_2 = {
      tooltip: {
        trigger: 'item'
      },
      legend: {
        orient: 'vertical',
        left: 'left',
      },
      series: [
        {
          center: ['70%', '50%'],
          name: 'Movie Categories',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: false,
            position: 'center'
          },
          labelLine: {
            show: false
          },
          data: [
            {value: 34, name: 'Crazy primitive 2'},
            {value: 23, name: 'Escape from dooms day'},
            {value: 13, name: 'Soul searching'},
            {value: 12, name: 'Eliminate the rascal'},
            {value: 30, name: 'Others'}
          ]
        }
      ]
    };
    this.pie_chart_2 = this.$echarts.init(document.getElementById("pie_chart_2"));
    this.pie_chart_2.setOption(pie_option_2)

  }
}
</script>
