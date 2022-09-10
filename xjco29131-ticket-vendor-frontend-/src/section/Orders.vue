<template>
  <v-data-table
      :headers="headers"
      :items="orders"
      sort-by="calories"
      class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar
          flat
      >
        <v-toolbar-title>Orders</v-toolbar-title>
        <v-divider
            class="mx-4"
            inset
            vertical
        ></v-divider>
        <v-spacer></v-spacer>
        <v-dialog
            v-model="dialog"
            width="800"
        >
          <template v-slot:activator="{ on, attrs }">
            <v-btn
                color="primary"
                dark
                class="mb-2"
                v-bind="attrs"
                v-on="on"
            >
              New Order
            </v-btn>
          </template>
          <v-card>
            <v-card-title class="elevation-0">
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-stepper v-model="e1" class="elevation-0">
              <v-stepper-header class="elevation-0">
                <v-stepper-step
                    :complete="e1 > 1"
                    step="1"
                >
                  Session
                </v-stepper-step>

                <v-divider></v-divider>

                <v-stepper-step
                    :complete="e1 > 2"
                    step="2"
                >
                  Seats
                </v-stepper-step>

                <v-divider></v-divider>

                <v-stepper-step step="3">
                  Payment
                </v-stepper-step>
              </v-stepper-header>

              <v-stepper-items>
                <v-stepper-content step="1">
                  <h3 class="mb-3">Choose Movie</h3>
                  <v-sheet height="230" width="100%" style="overflow-x: auto">
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
                  </v-sheet>
                  <h3 class="my-4">Choose Time</h3>
                  <v-select dense :items="times"  label="Times" v-model="editedItem.time"></v-select>

                </v-stepper-content>

                <v-stepper-content step="2">
                  <v-sheet style="display: flex">
                    <div style="height: 400px; width: 400px">
                      <SeatsChooser
                        v-on:rem_price="pri => (editedItem.rec_price=pri, editedItem.price=pri) "
                        v-on:seatsNum="num=>(changeSeatsNum(num))"
                        :category="toggle_seats"
                        ref="seats_chooser"
                      />
                    </div>
                    <div>
                      <h3 class="my-2">Ticket Category:</h3>
                      <v-btn-toggle
                          v-model="toggle_seats"
                          mandatory
                      >
                        <v-btn>Adult</v-btn>
                        <v-btn>Child</v-btn>
                        <v-btn>Elder</v-btn>

                      </v-btn-toggle>
                      <h3 class="mt-3">Ticket Number:</h3>
                      <v-container><v-row>
                        <v-col><h4>Adult</h4>{{ordinarySeatsNum}}</v-col>
                        <v-col><h4>Child</h4>{{childSeatNum}}</v-col>
                        <v-col><h4>Elder</h4>{{elderSeatsNum}}</v-col>
                        <v-col><h4>Total</h4>{{totalSeatsNum}}</v-col>
                      </v-row></v-container>

                      <v-btn depressed color="primary" @click.prevent="clearAll">Clear Chosen Seats</v-btn>

                    </div>

                  </v-sheet>


                </v-stepper-content>

                <v-stepper-content step="3">
                  <v-card>
                    <v-container>
                      <v-row dense>
                        <v-col><h3 style="text-align: center">Pay Method</h3></v-col>
                        <v-col><h3 style="text-align: center">Price</h3></v-col>
                        <v-col><h3 style="text-align: center">Discount</h3></v-col>
                      </v-row>
                      <v-row dense>
                        <v-col>
                          <v-sheet rounded outlined class="pa-2 fill-height">

                            <v-radio-group
                                v-model="editedItem.pay_method"
                            >
                              <v-radio
                                  v-for="method in all_pay_methods"
                                  :key="method.id"
                                  :value="method.value"
                              >
                                <template v-slot:label>
                                  <img  :src="method.logo" style="height: 1.2em" :alt="method.text"/>
                                </template>
                              </v-radio>
                            </v-radio-group>
                          </v-sheet>
                        </v-col>
                        <v-col>
                          <v-sheet rounded outlined class="pa-2">
                            <v-sheet outlined rounded class="pa-2 my-2">
                              <h4>Default Price</h4>
                              <div @change="editedItem.price=editedItem.rec_price">{{editedItem.rec_price}}</div>
                            </v-sheet>
                            <v-text-field
                                outlined
                                v-model="editedItem.price"
                                label="Actual Price"
                                class="mt-2"
                            ></v-text-field>
                            <v-btn width="100%" depressed color="primary" class="my-2" @click="editedItem.price = editedItem.rec_price">
                              <v-icon left>mdi-refresh</v-icon>Reset Actual Price
                            </v-btn>
                          </v-sheet>
                        </v-col>
                        <v-col>
                          <v-sheet rounded outlined class="pa-2 fill-height">
                            <v-combobox
                                :items="discounts"
                                label="Add Discounts"
                                multiple
                                clearable
                                small-chips
                                deletable-chips
                                v-model="selectedDiscount"
                            >
                              <template v-slot:item="{ index, item }">
                                <v-list-item @click.stop="multipleSelection(item)">{{item}}</v-list-item>
                              </template>
                              <template v-slot:selection="{ index, item }">
                                <v-chip close dark color="info" @click:close="deleteChip(item)">{{ item }}</v-chip>
                              </template>

                            </v-combobox>
                            <v-btn depressed color="primary" width="100%" @click="apply_discount()">Apply Discount</v-btn>
                          </v-sheet>
                        </v-col>
                      </v-row>
                    </v-container>
                  </v-card>

                </v-stepper-content>

              </v-stepper-items>
            </v-stepper>

            <v-card-actions>
              <v-btn
                  color="primary"
                  depressed
                  @click="e1===3?e1=1:e1+=1"
              >
                {{ e1===3?"Back":"Continue" }}
              </v-btn>
              <v-spacer></v-spacer>
              <v-btn
                  color="error"
                  text
                  @click="close"
              >
                Cancel
              </v-btn>
              <v-btn
                  color="primary"
                  text
                  @click="save"
                  :disabled="e1!==3"
              >
                Save
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
        <v-dialog v-model="dialogDelete" max-width="500px">
          <v-card>
            <v-card-title class="headline">Are you sure you want to delete this order?</v-card-title>
            <v-card-text>This action could not withdraw</v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="closeDelete">Cancel</v-btn>
              <v-btn color="blue darken-1" text @click="deleteItemConfirm">OK</v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:item.create_at_time="{ item }">
      {{item.create_at|to_normal_datetime}}
    </template>
    <template v-slot:item.actions="{ item }">
      <v-btn
          color="error"
          x-small
          icon
          @click="deleteItem(item)"
      >
        <v-icon>mdi-delete</v-icon>
      </v-btn>

    </template>

    <template v-slot:item.status="{item}">
      {{the_status(item.id)}}
    </template>

    <template v-slot:item.refund="{item}">
      <v-btn
          x-small
          depressed
          color="warning"
          href="/tickets/tickets.pdf"
          target="_blank"
          v-if="the_status(item.id) === 'Brought'"
      ><v-icon left>
        mdi-cash
      </v-icon>Refund
      </v-btn>    </template>

    <template v-slot:item.ticket="{}">
      <v-btn
          icon
          x-small
          href="/tickets/tickets.pdf"
          target="_blank"
      ><v-icon>
        mdi-download
      </v-icon>
      </v-btn>

    </template>

    <template v-slot:item.pay_at_time="{ item }">
      {{item.pay_at|to_normal_datetime}}
    </template>

    <template v-slot:no-data>
      <v-btn
          color="primary"
          @click="initialize"
      >
        Reset
      </v-btn>
    </template>
  </v-data-table>
</template>

<script>

import moment from "moment"
import SeatsChooser from "@/components/SeatChooser";

export default {
  name: "Orders",
  components: {SeatsChooser},

  filters: {
    to_normal_datetime: function (iso_time) {
      if (moment(iso_time).isValid())
        return moment(iso_time).format('MMMM Do YYYY, h:mm:ss a')
    },
  },

  data: () => ({
    dialog: false,
    dialogDelete: false,
    ordinarySeatsNum: 0,
    childSeatNum: 0,
    elderSeatsNum: 0,
    totalSeatsNum: 0,
    toggle_seats: 0,
    e1: 1,
    selectedDiscount:[],
    headers: [
      {text: 'Id', value: 'id'},
      {text: 'User', value: 'user'},
      {text: 'Tickets', value: 'tickets'},
      {text: 'Create Time', value: 'create_at_time'},
      {text: 'Price', value: 'price'},
      {text: 'Pay Method', value: 'pay_method'},
      {text: 'Pay Time', value: 'pay_at_time'},
      {text: 'Status', value: 'status'},
      {text: 'Do Refund', value: 'refund'},
      {text: 'PDF Ticket', value: 'ticket', sortable: false},
      {text: 'Actions', value: 'actions', sortable: false},
    ],
    orders: [],
    editedIndex: -1,
    all_pay_methods: [
      {id:0,value:"cash", text: "cash", logo:require("@/assets/payment/Cash.svg")},
      {id:1, value:"alipay in face",text: "alipay", logo:require("@/assets/payment/Alipay.svg")},
      {id:3, value:"visa in face", text: "visa", logo :require("@/assets/payment/Visa.svg")},
      {id:4, value:"mastercard in face", text: "mastercard", logo: require("@/assets/payment/Mastercard.svg")}

    ],
    times: ['8:30-10:30', '11:00-13:00', '13:30-15:30', '16:00-18:00', '18:30-20:30', '21:00-23:00', '23:30-1:30'],

    editedItem: {
      id: 34,
      user: 0,
      price: 0,
      pay_method: "cash",
      create_at: "2020-01-01T00:00:00+08:00",
      pay_at: "2020-01-01T00:00:00+08:00",
      tickets: [123, 124, 125],
      rec_price: 0,
      time: null
    },
    defaultItem: {
      id: 34,
      user: 0,
      price: 0,
      pay_method: "cash",
      create_at: "2020-01-01T00:00:00+08:00",
      pay_at: "2020-01-01T00:00:00+08:00",
      tickets: [123, 124, 125],
      rec_price: 0,
      time: null

    },
    selected_movie_id: null,

  }),

  computed: {
    formTitle() {
      return this.editedIndex === -1 ? 'New Order' : 'Edit Order'
    },
    movies: function () {
      return this.$store.state.movies
    },
    discounts:function (){
      let rel = []
      for(let i=95; i>0;i-=5){
        rel.push(i+"%")
      }
      return rel;
    }
  },

  watch: {
    dialog(val) {
      val || this.close()
    },
    dialogDelete(val) {
      val || this.closeDelete()
    },
  },

  created() {
    this.initialize()
  },


  methods: {

    multipleSelection(item) {
      this.selectedDiscount.push(item);
    },
    deleteChip(item) {
      this.selectedDiscount = this.selectedDiscount.filter(x => x !== item);
    },

    apply_discount: function (){
      this.selectedDiscount.forEach(
          disc => this.editedItem.price = disc.replace("%","")/100*this.editedItem.price
      )
      this.selectedDiscount = []
    },

    the_status: function (id){
      return (id <= 4) ? "Used":(id===5?"Refunded":"Brought")
    },
    clearAll() {
      this.$refs.seats_chooser.clearAll()
    },
    if_selected: function (movie_id) {
      return this.selected_movie_id === movie_id
    },

    movie_click: function (movie_id) {
      if (movie_id === this.selected_movie_id) {
        this.selected_movie_id = null
      } else if (this.selected_movie_id === null) {
        this.selected_movie_id = movie_id
      }
    },

    changeSeatsNum: function (num){
      this.ordinarySeatsNum = num[0]
      this.childSeatNum = num[1]
      this.elderSeatsNum = num[2]
      this.totalSeatsNum=num[0]+num[1]+num[2]
    },

    initialize() {
      this.orders = [
        {
          id: 1,
          user: 0,
          price: 0,
          pay_method: "cash",
          create_at: "2020-04-12T06:12:44+08:00",
          pay_at: "2020-04-12T06:12:44+08:00",
          tickets: [11, 12]
        },
        {
          id: 2,
          user: 2,
          price: 10,
          pay_method: "visa in face",
          create_at: "2020-04-12T08:43:42+08:00",
          pay_at: "2020-04-12T08:43:42+08:00",
          tickets: [15, 16, 17]
        },
        {
          id: 3,
          user: 3,
          price: 20,
          pay_method: "cash",
          create_at: "2020-04-12T09:02:40+08:00",
          pay_at: "2020-04-12T09:02:40+08:00",
          tickets: [11, 12]
        },
        {
          id: 4,
          user: 1,
          price: 10,
          pay_method: "alipay in face",
          create_at: "2020-04-12T10:12:42+08:00",
          pay_at: "2020-04-12T10:12:42+08:00",
          tickets: [11, 12]
        },
        {
          id: 5,
          user: 1,
          price: 20,
          pay_method: "cash",
          create_at: "2020-04-12T11:23:44+08:00",
          pay_at: "2020-04-12T11:23:44+08:00",
          tickets: [11, 12]
        },
        {
          id: 6,
          user: 0,
          price: 40,
          pay_method: "alipay online",
          create_at: "2020-04-12T12:22:42+08:00",
          pay_at: "2020-04-12T12:22:42+08:00",
          tickets: [11, 12]
        },
        {
          id: 7,
          user: 0,
          price: 30,
          pay_method: "cash",
          create_at: "2020-01-01T00:00:00+08:00",
          pay_at: "2020-01-01T00:00:00+08:00",
          tickets: [11, 12]
        },
      ]
    },

    rec_price(re_price, editedItem) {
      editedItem.rec_price = re_price
    },
    editItem(item) {
      this.editedIndex = this.orders.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },

    deleteItem(item) {
      this.editedIndex = this.orders.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialogDelete = true
    },

    deleteItemConfirm() {
      this.orders.splice(this.editedIndex, 1)
      this.closeDelete()
    },

    close() {
      this.dialog = false
      this.e1 = 1;
      this.selected_movie_id = null;
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      })
    },

    closeDelete() {
      this.dialogDelete = false
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      })
    },

    save() {
      if (this.editedIndex > -1) {
        Object.assign(this.orders[this.editedIndex], this.editedItem)
      } else {
        this.editedItem.create_at = moment.utc()
        this.editedItem.pay_at = moment.utc()
        this.orders.push(this.editedItem)
      }
      this.close()
    },
  },
}
</script>
