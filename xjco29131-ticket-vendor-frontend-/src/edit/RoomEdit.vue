<template>

  <v-container style="background-color: white; margin-top: 12px" >
    <v-row>
      <v-col>
        <v-toolbar
          flat
        >
          <v-toolbar-title>Rooms</v-toolbar-title>
          <v-divider
            vertical
            inset
            class="mx-4"
          ></v-divider>
          <v-toolbar-title>Edit</v-toolbar-title>

          <v-spacer></v-spacer>
          <v-btn-toggle v-model="drawWhat" class="mx-2" dense>
            <v-btn>seats</v-btn>
            <v-btn>VIP</v-btn>
          </v-btn-toggle>
          <v-btn color="primary" class="mr-2">Save</v-btn>
          <v-btn color="error" to="/Rooms/">Cancel</v-btn>
        </v-toolbar>
      </v-col>
    </v-row>
    <v-spacer></v-spacer>
    <v-row>
      <v-col>
        <!-- Seat system  -->
        <v-sheet  style="display: flex; min-height: 30rem ; width: 100%; justify-content: center; align-items: center; ">

          <div class="seat_content">
            <div style="width: 100%; display: flex; justify-content: space-between" class="my-2" v-if="curStages === 'drawSeats' ">
              <v-btn small outlined @click="addSeatsLine(height+1)"><v-icon>mdi-plus</v-icon> New Line</v-btn>
              <v-btn small outlined @click="addSeatsColumn(width+1)"><v-icon>mdi-plus</v-icon> New Column</v-btn>

            </div>
            <div v-for="n in height" :key="height-n+1" class="seats_row" >
              <v-btn icon plain x-small v-on:click="addSeatsLine(height-n+1)" v-if="curStages === 'drawSeats' " >
                <v-icon>mdi-plus</v-icon>
              </v-btn>
              <v-btn icon plain x-small v-on:click="deleteSeatsLine(height-n+1)" v-if="curStages === 'drawSeats' " >
                <v-icon>mdi-minus</v-icon>
              </v-btn>
              <div class="seat_side_num">{{height-n+1}}</div>
              <v-btn icon class="seat_btn"
                     v-for="m in width" :key="m"
                     outlined
                     :disabled="curStages !=='drawSeats' && !hasSeat(m,height-n+1)"
                     @click="btnEvent(m,height-n+1)"
                     :color="ifVIP(m,height-n+1) ? 'amber' : '' "
              >
                <v-icon v-if="hasSeat(m,height-n+1)">mdi-seat</v-icon>
              </v-btn>
            </div>

            <div class="seat_btn_line">
              <div v-for="m in width" :key="m" class="seat_btm_col" >
                <div class="seat_btm_num">{{m}}</div>

                <v-btn icon plain x-small v-on:click="addSeatsColumn(m)" v-if="curStages === 'drawSeats' ">
                  <v-icon>mdi-plus</v-icon>
                </v-btn>

                <v-btn icon plain x-small v-on:click="deleteSeatsColumn(m)" v-if="curStages === 'drawSeats' ">
                  <v-icon>mdi-minus</v-icon>
                </v-btn>

              </div>
            </div>

          </div>
        </v-sheet>
      </v-col>

      <v-col cols="4">
        <v-sheet outlined rounded class="pa-4 elevation-1">
          <v-row>
            <v-col><v-text-field
                v-model="cin_name"
                label="Name"
                style="width: 200px"
            ></v-text-field></v-col>
          </v-row>

          <v-divider></v-divider>

          <v-row>
            <v-col>
              <v-sheet class="pa-2 my-1" width="200">
                <h4>Number Of Row:</h4>
                <div>{{height}}</div>
              </v-sheet>
            </v-col>
          </v-row>

          <v-divider></v-divider>

          <v-row>
            <v-col>
              <v-sheet class="pa-2 my-1" width="200">
                <h4>Number Of Column:</h4>
                <div>{{width}}</div>
              </v-sheet>
            </v-col>
          </v-row>

          <v-divider></v-divider>

          <v-row>
            <v-col>
              <v-sheet class="pa-2 my-1" width="200">
                <h4>Number Of Seats:</h4>
                <div>{{numSeats}}</div>
              </v-sheet>
            </v-col>
          </v-row>
          <v-divider></v-divider>
          <v-row>
            <v-col>
              <v-sheet class="pa-2 my-1" width="200">
                <h4>Number Of VIP Seats:</h4>
                <div>{{numVIP}}</div>
              </v-sheet>
            </v-col>
          </v-row>

        </v-sheet>
      </v-col>
    </v-row>
  </v-container>


</template>

<script>
export default {
  name: "RoomEdit",
  data: () => ({
    cin_name:"Room 1 ",
    seats:[
      {id:12,x:4,y:6,vip:true},
      {id:1,x:2,y:7,vip:false},
      {id:2,x:4,y:9,vip:false},
      {id:13,x:6,y:3,vip:false},
    ],
    allStages:["drawSeats","drawVIP","preview"],
    drawWhat: 0
  }),
  computed:{
    width (){
      if (this.seats.length === 0) return 0
      return this.seats.reduce((acc,cur) => acc.x > cur.x ? acc : cur).x
    },
    height (){
      if (this.seats.length === 0) return 0
      return this.seats.reduce((acc,cur) => acc.y > cur.y ? acc : cur).y
    },
    curStages(){
      return this.allStages[this.drawWhat]
    },
    numSeats(){
      return this.seats.length;
    },
    numVIP(){
      return this.seats.reduce((acc, cur) => (cur.vip ? acc+1 :acc ),0)
    }
  },
  methods:{

    btnEvent(x, y){
      if(this.curStages === 'drawSeats')
        this.switchCoordinate(x, y)
      else if (this.curStages === 'drawVIP')
        this.switchVIP(x, y)
    },

    switchVIP(x, y){
      let index = this.seats.findIndex(seat => seat.x===x && seat.y===y)
      if (index !== -1)
        this.seats[index].vip = ! this.seats[index].vip
    },

    ifVIP(x, y){
      let index = this.seats.findIndex(seat => seat.x===x && seat.y===y)
      if (index === -1) return false
      return this.seats[index].vip
    },

    hasSeat(x, y){
      return this.seats.find((seat) =>
        ( seat.x === x && seat.y === y )) !== undefined;
    },
    deleteCoordinate(x, y){
      this.seats.splice(this.seats.findIndex(item =>
          (item.x === x && item.y ===y ) ), 1)
    },
    addCoordinate(x, y){
      this.seats.push({id:-1,x:x,y:y,vip:false})
    },
    switchCoordinate(x,y){
      if(this.hasSeat(x,y))
        this.deleteCoordinate(x,y);
      else
        this.addCoordinate(x,y);
    },
    addSeatsLine(y){
      for( let x=1; x<= this.width; x++){
        if(! this.hasSeat(x,y))
          this.addCoordinate(x,y)
      }
    },
    deleteSeatsLine(y){
      for( let x=1; x<= this.width; x++) {
        if (this.hasSeat(x, y))
          this.deleteCoordinate(x, y)
      }
    },
    addSeatsColumn(x){
      for (let y=1; y<=this.height;y++)
        if (! this.hasSeat(x, y))
          this.addCoordinate(x, y)
    },
    deleteSeatsColumn(x){
      for (let y=1; y<=this.height;y++)
        if (this.hasSeat(x, y))
          this.deleteCoordinate(x, y)
    },
  }
}
</script>

<style scoped>

.seat_content{

}
.seat_btn_line{
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  width: 100%;
  padding: 0 .3rem;
}
.seat_btm_col{
  display: flex;
  flex-direction: column;
  align-items: center
}

.seat_btm_num{
  margin: 0 .2rem;
  width: 36px;
  font-size: 1.2rem;
  text-align: center
}

.seats_row{
  display: flex;
  flex-direction: row;
  margin: 0 .3rem;
  align-items: center
}

.seat_side_num{
  margin: .2rem .4rem;
  text-align: center;
  font-size: 1.2rem;
  width: 1.3rem;
}

.seat_btn{
  margin: .2rem

}
</style>