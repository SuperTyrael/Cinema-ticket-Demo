<template>
  <div style="height: 100%;width: 100%; padding: 4px">
    <v-container>
      <v-row>
        <v-col>
          <v-card
              style="  display: flex !important; flex-direction: column;"
              flat
          >
            <v-card-title>
              <span>Movie</span>
              <v-spacer></v-spacer>
              <v-btn depressed color="primary" @click="reset_movies"><v-icon left>mdi-refresh</v-icon> Reset</v-btn>
            </v-card-title>


            <v-card-text style="overflow-x: auto;">
              <div style="display: inline-flex">
                <v-sheet v-for="movie in movies" :key="movie.id"
                         width="120"
                         class="mx-2 pa-2"
                         rounded
                         elevation="1"
                         :dark="!!if_selected(movie.id)"
                         :color="if_selected(movie.id)?'primary':''"
                         @click="movie_click(movie.id)"
                >
                  <v-img :src="movie.pic_src" max-width="80" max-height="120" class="mx-auto"></v-img>
                  <div style="text-align: center;">{{movie.title}}</div>
                </v-sheet>
              </div>
            </v-card-text>
          </v-card>

        </v-col>
      </v-row>

      <v-row>
        <v-col>
          <v-sheet rounded width="100%" height="400" min-width="600">
            <v-row>
              <v-col v-for="index in 3" :key="index">
                <v-sheet
                    v-if="selected_id.length >= index"
                    class="ma-2 pa-2"
                >
                  <v-img class="mx-auto" :src=getMovieById(selected_id[index-1]).pic_src max-width="140px"></v-img>
                  <h2 style="width: 100%; text-align: center">{{getMovieById(selected_id[index-1]).title}}</h2>
                  <div><span class="title">Total Taking:</span><span>{{getMovieById(selected_id[index-1]).totalTaking}}</span></div>
                  <div><span class="title">Average Taking Per Day:</span><span>{{getMovieById(selected_id[index-1]).avgDayTaking}}</span></div>
                </v-sheet>
              </v-col>


            </v-row>
          </v-sheet>
        </v-col>
      </v-row>

      <v-row>
        <v-col>
          <v-sheet rounded id="sta_chart" width="100%" height="400" min-width="600"></v-sheet>
        </v-col>
      </v-row>
    </v-container>

  </div>
</template>

<script>
export default {
  name: "Comparison",
  computed:{
    movies: function (){return this.$store.state.movies},
  },
  data:()=>({
    title:"Movie Weekly Taking Comparison",
    selected_id : [],
    myChart : null,
    chartOptions : {
      legend: {},
      tooltip: {
        axisPointer: {
          type: 'cross'
        }
      },
      xAxis:{
        type: 'category',
        data: [],
        axisTick: {
          alignWithLabel: true
        },
        axisLine: {
          onZero: false,
        },
      },
      yAxis: {
        type: 'value'
      },
      series: []
    }

  }),
  mounted: function (){
    this.myChart = this.$echarts.init(document.getElementById("sta_chart"));
    console.log("success")
  },

  methods:{
    if_selected: function(movie_id) {
      return this.selected_id.includes(movie_id)
    },
    reset_movies:function (){
      this.selected_id=[];
      this.myChart.clear();
    },
    movie_click: function (movie_id){
      let i = this.selected_id.findIndex(element=>element === movie_id)
      if ( i !== -1){
        this.selected_id.splice(i,1);
      }
      else if(this.selected_id.length !==3){
        this.selected_id.push(movie_id)
      }


      this.drawGraph();
    },

    setChartData: function (){
      this.chartOptions.series = [];
      for(let movie of this.$store.state.movies ){
        if (this.if_selected(movie.id)){
          this.chartOptions.series.push({
            name: movie.title,
            data: movie.sell_weeks,
            type: 'line',
          });
        }
      }
    },

    setXAxis: function (){
      let maxWeek = 0;
      for(let seriesItem of this.chartOptions.series){
        if (maxWeek < seriesItem.data.length)
          maxWeek = seriesItem.data.length
      }

      let weeks=[];
      for(let i=1;i<=maxWeek;i++){
        let thisWeak = "w" + i;
        weeks.push(thisWeak)
      }

      this.chartOptions.xAxis.data = weeks
    },


    drawGraph: function (){
      this.setChartData();
      this.setXAxis();
      console.log(this.chartOptions.series.length)
      this.myChart.clear();
      if(this.selected_id.length !== 0)
        this.myChart.setOption(this.chartOptions);
    },

    getMovieById:function (movie_id) {
      return this.movies.find(element => element.id === movie_id)
    }
  }
}
</script>

<style scoped>

</style>