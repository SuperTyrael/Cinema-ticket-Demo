<template>
    <!-- Seat system  -->
  <div
    id="bg"
    style="display: flex; height: 100% ; width: 100%; justify-content: center; align-items: center"
  >
    <div class="seat_content">
      <div class="seat_top_line">
        <div v-for="m in width" :key="m" class="seat_top_col">
          <div class="seat_top_num">{{ m }}</div>
        </div>
      </div>
      <div v-for="n in height" :key="height - n + 1" class="seats_row">
        <div class="seat_side_num">{{ height - n + 1 }}</div>
        <v-btn
          class="seat_btn"
          v-for="m in width"
          :key="m"
          tile
          fab
          depressed
          :dark="isChosen(m, height - n + 1)"
          :text="!isChosen(m, height - n + 1)"
          :disabled="!hasSeat(m, height - n + 1) || isOccupied(m,height-n+1)"
          @click="switchChosen(m, height - n + 1)"
          :color="
            ifVIP(m, height - n + 1)
              ? 'amber'
              : isChosen(m, height - n + 1)
              ? 'primary'
              : ''
          "
        >
          <v-icon v-if="hasSeat(m, height - n + 1)">{{the_show_icon(m,height-n+1)}}</v-icon>
        </v-btn>
      </div>
      <div style="display: flex; width: 100%; margin: .2rem 0">
        <div class="seat_side_num"></div>
        <div style="border: 2px solid; width:70%; text-align: center; margin: 0 auto ">screen</div>
      </div>
    </div>

    <div style="display: none">{{rem_price}}</div>
  </div>
</template>

<script>
export default {
  name: "SeatsChooser",
  props:['category'],
  data: () => ({
    seats: [
      { id: 0, x: 0 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 1, x: 1 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 2, x: 2 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 3, x: 3 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 4, x: 4 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 5, x: 5 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 6, x: 6 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 7, x: 7 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 8, x: 8 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 9, x: 9 , y: 0, vip: false, hasChosen: false, hasOccupied:false },
      { id: 100, x: 0 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 101, x: 1 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 102, x: 2 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 103, x: 3 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 104, x: 4 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 105, x: 5 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 106, x: 6 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 107, x: 7 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 108, x: 8 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 109, x: 9 , y: 1, vip: false, hasChosen: false, hasOccupied:false },
      { id: 200, x: 0 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 201, x: 1 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 202, x: 2 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 203, x: 3 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 204, x: 4 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 205, x: 5 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 206, x: 6 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 207, x: 7 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 208, x: 8 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 209, x: 9 , y: 2, vip: false, hasChosen: false, hasOccupied:false },
      { id: 300, x: 0 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 301, x: 1 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 302, x: 2 , y: 3, vip: true, hasChosen: false, hasOccupied:false },
      { id: 303, x: 3 , y: 3, vip: true, hasChosen: false, hasOccupied:false },
      { id: 304, x: 4 , y: 3, vip: true, hasChosen: false, hasOccupied:false },
      { id: 305, x: 5 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 306, x: 6 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 307, x: 7 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 308, x: 8 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 309, x: 9 , y: 3, vip: false, hasChosen: false, hasOccupied:false },
      { id: 400, x: 0 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 401, x: 1 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 402, x: 2 , y: 4, vip: true, hasChosen: false, hasOccupied:false },
      { id: 403, x: 3 , y: 4, vip: true, hasChosen: false, hasOccupied:false },
      { id: 404, x: 4 , y: 4, vip: true, hasChosen: false, hasOccupied:false },
      { id: 405, x: 5 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 406, x: 6 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 407, x: 7 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 408, x: 8 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 409, x: 9 , y: 4, vip: false, hasChosen: false, hasOccupied:false },
      { id: 500, x: 0 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 501, x: 1 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 502, x: 2 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 503, x: 3 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 504, x: 4 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 505, x: 5 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 506, x: 6 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 507, x: 7 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 508, x: 8 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 509, x: 9 , y: 5, vip: false, hasChosen: false, hasOccupied:false },
      { id: 600, x: 0 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 601, x: 1 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 602, x: 2 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 603, x: 3 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 604, x: 4 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 605, x: 5 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 606, x: 6 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 607, x: 7 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 608, x: 8 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 609, x: 9 , y: 6, vip: false, hasChosen: false, hasOccupied:false },
      { id: 700, x: 0 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 701, x: 1 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 702, x: 2 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 703, x: 3 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 704, x: 4 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 705, x: 5 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 706, x: 6 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 707, x: 7 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 708, x: 8 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 709, x: 9 , y: 7, vip: false, hasChosen: false, hasOccupied:false },
      { id: 800, x: 0 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 801, x: 1 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 802, x: 2 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 803, x: 3 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 804, x: 4 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 805, x: 5 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 806, x: 6 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 807, x: 7 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 808, x: 8 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 809, x: 9 , y: 8, vip: false, hasChosen: false, hasOccupied:false },
      { id: 900, x: 0 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 901, x: 1 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 902, x: 2 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 903, x: 3 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 904, x: 4 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 905, x: 5 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 906, x: 6 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 907, x: 7 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 908, x: 8 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
      { id: 909, x: 9 , y: 9, vip: false, hasChosen: false, hasOccupied:false },
    ],
    ordinarySeats:[],
    childSeats: [],
    elderSeats:[]
  }),
  computed: {
    width() {
      if (this.seats.length === 0) return 0;
      return this.seats.reduce((acc, cur) => (acc.x > cur.x ? acc : cur)).x;
    },
    height() {
      if (this.seats.length === 0) return 0;
      return this.seats.reduce((acc, cur) => (acc.y > cur.y ? acc : cur)).y;
    },
    rem_price(){
      let result =  this.seats.reduce((acc, cur) => (cur.hasChosen ? (cur.vip?acc+30:acc+20) :acc ),0)
      this.$emit('rem_price',result)
      this.$emit('seatsNum',[this.ordinarySeats.length,this.childSeats.length,this.elderSeats.length])
      return result
    },


  },
  methods: {
    clearAll(){
      console.log("This is ssss")
      this.seats.forEach(element => element.hasChosen=false)
      this.childSeats = []
      this.ordinarySeats = []
      this.elderSeats = []
    },
    the_show_icon(x,y){
      let index = this.seats.findIndex((seat) => seat.x === x && seat.y === y);

      if (this.childSeats.includes(index))
        return "C"
      else if (this.elderSeats.includes(index))
        return "E"
      else
        return "mdi-seat"
    },

    switchChosen(x, y) {
      let index = this.seats.findIndex((seat) => seat.x === x && seat.y === y);

      if (index !== -1){

        if (this.seats[index].hasChosen === true){
          this.childSeats = this.childSeats.filter(element => element!==index)
          this.ordinarySeats = this.ordinarySeats.filter(element => element!==index)
          this.elderSeats = this.elderSeats.filter(element => element!==index)
        }
        else {
          if (this.category === 1){
            this.childSeats.push(index)
          }
          else if (this.category === 0){
            this.ordinarySeats.push(index)
          }
          else if (this.category === 2){
            this.elderSeats.push(index)
          }
        }

        this.seats[index].hasChosen = !this.seats[index].hasChosen;

      }
    },

    ifVIP(x, y) {
      let index = this.seats.findIndex((seat) => seat.x === x && seat.y === y);
      if (index === -1) return false;
      return this.seats[index].vip;
    },

    hasSeat(x, y) {
      return (
        this.seats.find((seat) => seat.x === x && seat.y === y) !== undefined
      );
    },

    isChosen(x, y) {
      let index = this.seats.findIndex((seat) => seat.x === x && seat.y === y);
      if (index === -1) return false;
      return this.seats[index].hasChosen;
    },

    isOccupied(x, y) {
      let index = this.seats.findIndex((seat) => seat.x === x && seat.y === y);
      if (index === -1) return false;
      return this.seats[index].hasOccupied;
    },
  },
};
</script>

<style scoped>
.seat_top_line {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  width: 100%;
}

.seat_top_num {
  width: 32px;
  font-size: 1.2rem;
  text-align: center;
}

.seats_row {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.seat_side_num {
  margin: 0 0.2rem;
  text-align: center;
  font-size: 1.2rem;
  width: 2rem;
}

.seat_btn {
  width: 32px !important;
  height: 32px !important;
}
</style>
