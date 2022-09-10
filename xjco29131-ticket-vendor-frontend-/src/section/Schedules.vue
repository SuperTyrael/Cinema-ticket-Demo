<template>
  <v-data-table
      :headers="headers"
      :items="tickets"
      sort-by="calories"
      class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar
          flat
      >
        <v-toolbar-title>Schedule</v-toolbar-title>
        <v-divider
            class="mx-4"
            inset
            vertical
        ></v-divider>
        <v-spacer></v-spacer>



        <v-dialog
            v-model="dialog"
            max-width="500px"
        >
          <template v-slot:activator="{ on, attrs }">
            <v-btn
                color="primary"
                dark
                class="mb-2"
                v-bind="attrs"
                v-on="on"
            >
              New Item
            </v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col
                      cols="6"
                  >
                    <v-select
                      :items="avl_times"
                      v-model="editedItem.online_at_time"
                      label="day schedule"
                    >
                    </v-select>
                  </v-col>
                  <v-col
                      cols="6"
                  >
                    <v-menu
                        ref="menu"
                        v-model="menu"
                        :close-on-content-click="false"
                        transition="scale-transition"
                        offset-y
                        min-width="auto"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <v-text-field
                            v-model="editedItem.online_at_date"
                            label="Date"
                            prepend-icon="mdi-calendar"
                            readonly
                            v-bind="attrs"
                            v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                          v-model="editedItem.online_at_date"
                          no-title
                          scrollable
                          :show-current="new Date().toISOString().substr(0, 10)"
                      >
                      </v-date-picker>
                    </v-menu>

                  </v-col>
                </v-row>
                <v-row>
                  <v-col
                      cols="6"
                  >
                    <v-text-field
                        v-model="editedItem.normal_price"
                        label="normal price"
                        type="number"
                    ></v-text-field>
                  </v-col>
                  <v-col
                      cols="6"
                  >
                    <v-text-field
                        v-model="editedItem.vip_price"
                        label="vip price"
                        type="number"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col
                      cols="8"
                  >
                    <v-select
                        :items="movies"
                        v-model="editedItem.movie"
                        label="Movie"
                    ></v-select>
                  </v-col>
                  <v-col
                      cols="4"
                  >
                    <v-select
                        :items="rooms"
                        v-model="editedItem.room"
                        label="Room"
                    ></v-select>
                  </v-col>
                </v-row>

              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                  color="blue darken-1"
                  text
                  @click="close2"
              >
                Cancel
              </v-btn>
              <v-btn
                  color="blue darken-1"
                  text
                  @click="save"
              >
                Save
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <v-dialog
            v-model="dialog2"
            max-width="500px"
        >
          <template v-slot:activator="{ on, attrs }">
            <v-btn
                color="primary"
                dark
                class="mb-2 mx-2"
                v-bind="attrs"
                v-on="on"
            >
              Bash Generate
            </v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col
                      cols="6"
                  >
                    <v-menu
                        ref="menu"
                        v-model="menu3"
                        :close-on-content-click="false"
                        transition="scale-transition"
                        offset-y
                        min-width="auto"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <v-text-field
                            v-model="bashBase.start_date"
                            label="Start Date"
                            prepend-icon="mdi-calendar"
                            readonly
                            v-bind="attrs"
                            v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                          v-model="bashBase.start_date"
                          no-title
                          scrollable
                          :show-current="new Date().toISOString().substr(0, 10)"
                      >
                      </v-date-picker>
                    </v-menu>

                  </v-col>

                  <v-col
                      cols="6"
                  >
                    <v-menu
                        ref="menu"
                        v-model="menu2"
                        :close-on-content-click="false"
                        transition="scale-transition"
                        offset-y
                        min-width="auto"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <v-text-field
                            v-model="bashBase.end_date"
                            label="End Date"
                            prepend-icon="mdi-calendar"
                            readonly
                            v-bind="attrs"
                            v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                          v-model="bashBase.end_date"
                          no-title
                          scrollable
                          :show-current="new Date().toISOString().substr(0, 10)"

                      >
                      </v-date-picker>
                    </v-menu>

                  </v-col>

                </v-row>
                <v-row>
                  <v-col
                      cols="6"
                  >
                    <v-text-field
                        v-model="bashBase.normal_price"
                        label="normal price"
                        type="number"
                    ></v-text-field>
                  </v-col>
                  <v-col
                      cols="6"
                  >
                    <v-text-field
                        v-model="bashBase.vip_price"
                        label="vip price"
                        type="number"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col
                      cols="8"
                  >
                    <v-select
                        :items="movies"
                        v-model="bashBase.movie"
                        label="Movie"
                    ></v-select>
                  </v-col>
                  <v-col
                      cols="4"
                  >
                    <v-select
                        :items="rooms"
                        v-model="bashBase.room"
                        label="Room"
                    ></v-select>
                  </v-col>
                </v-row>

                <v-row>
                  <v-col >
                    <v-select
                    label="Period"
                    >
                    </v-select>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                  color="blue darken-1"
                  text
                  @click="close"
              >
                Cancel
              </v-btn>
              <v-btn
                  color="blue darken-1"
                  text
                  @click="bashGen"
              >
                Save
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>


        <v-dialog v-model="dialogDelete" max-width="500px">
          <v-card>
            <v-card-title class="headline">Are you sure you want to delete this item?</v-card-title>
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

    <template v-slot:item.online_at_time="{ item }">
      {{item.online_at|to_normal_datetime}}
    </template>

    <template v-slot:item.user="{ item }">
      <a href="/#/Accounts/detail/11">{{item.user_id}}</a>
    </template>

    <template v-slot:item.actions="{ item }">
      <v-icon
          small
          class="mr-2"
          @click="editItem(item)"
      >
        mdi-pencil
      </v-icon>
      <v-icon
          small
          @click="deleteItem(item)"
      >
        mdi-delete
      </v-icon>
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
export default {
  name: "Schedules",
  data: () => ({
    dialog: false,
    dialog2: false,
    dialogDelete: false,
    headers: [
      { text: 'Id', value: 'id' },
      { text: 'Online Time', value: 'online_at_time' },
      { text: 'Create Time', value: 'create_at_time' },
      { text: 'Room', value: 'room' },
      { text: 'Movie', value: 'movie' },
      { text: 'Normal Price', value: 'normal_price' },
      { text: 'VIP Price', value: 'vip_price' },
      { text: 'Actions', value: 'actions', sortable: false },
    ],
    tickets: [
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
      {
        id : 3,
        online_at: "2020-04-01T10:20:33+08:00",
        online_at_date: "",
        online_at_time: 0,
        room: 1,
        movie: "The truman show",
        create_at: "2020-01-01T00:00:00+08:00",
        normal_price: 0,
        vip_price:0
      },
    ],
    editedIndex: -1,
    editedItem: {
      id : 3,
      online_at: "2020-04-01T10:20:33+08:00",
      online_at_date: "",
      online_at_time: 0,
      room: 1,
      movie: "The truman show",
      create_at: "2020-01-01T00:00:00+08:00",
      normal_price: 0,
      vip_price:0
    },
    defaultItem: {
      id : 3,
      online_at: "2020-01-01T00:00:00+08:00",
      online_at_date: "",
      online_at_time: 0,
      room: 1,
      movie: "The truman show",
      create_at: "2020-01-01T00:00:00+08:00",
      normal_price: 0,
      vip_price:0
    },
    bashBase:{
      start_date:"",
      end_date:"",
      periods:[false,false,false,false,false,false],
      movie: "",
      create_at: "2020-01-01T00:00:00+08:00",
      normal_price: 0,
      vip_price:0
    },
    menu:false,
    menu2:false,
    menu3:false,
    movies:['The Truman Show', '1917'],
    rooms:[0,1,2],
    avl_times:[0,1,2,3,4,5],
  }),

  computed: {
    formTitle () {
      return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
    },
  },

  watch: {
    dialog (val) {
      val || this.close()
    },
    dialogDelete (val) {
      val || this.closeDelete()
    },
  },

  created () {
    this.initialize()
  },

  filters:{
    to_normal_datetime : function (iso_time) {
      if ( moment(iso_time).isValid())
        return moment(iso_time).format('MMMM Do YYYY, h:mm:ss a')
    }
  },

  methods: {
    initialize () {
      this.tickets = [
        {
          id : 1,
          online_at: "2021-04-01T08:00:00+08:00",
          room: 1,
          movie: "The truman show",
          create_at: "2020-04-12T12:23:21+08:00",
          normal_price: 10,
          vip_price:20
        },
        {
          id : 2,
          online_at: "2021-04-01T08:00:00+08:00",
          room: 1,
          movie: "The truman show",
          create_at: "2020-04-12T12:14:32+08:00",
          normal_price: 10,
          vip_price:20
        },
        {
          id : 3,
          online_at: "2021-04-01T08:00:00+08:00",
          room: 1,
          movie: "The truman show",
          create_at: "2020-04-12T09:12:31+08:00",
          normal_price: 10,
          vip_price:20
        },        {
          id : 4,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "The truman show",
          create_at: "2020-04-12T10:11:12+08:00",
          normal_price: 10,
          vip_price:20
        },        {
          id : 5,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "The truman show",
          create_at: "2020-04-12T12:13:41+08:00",
          normal_price: 10,
          vip_price:20
        },        {
          id : 6,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "Escape",
          create_at: "2020-04-12T13:15:12+08:00",
          normal_price: 10,
          vip_price:30
        },
        {
          id : 7,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "Escape",
          create_at: "2020-04-12T13:15:12+08:00",
          normal_price: 10,
          vip_price:30
        },
        {
          id : 8,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "Escape",
          create_at: "2020-04-12T13:15:12+08:00",
          normal_price: 10,
          vip_price:30
        },
        {
          id : 9,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "Escape",
          create_at: "2020-04-12T13:15:12+08:00",
          normal_price: 10,
          vip_price:30
        },
        {
          id : 10,
          online_at: "2021-04-03T08:00:00+08:00",
          room: 1,
          movie: "Escape",
          create_at: "2020-04-12T13:15:12+08:00",
          normal_price: 10,
          vip_price:30
        },
      ]
    },

    editItem (item) {
      this.editedIndex = this.tickets.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },

    deleteItem (item) {
      this.editedIndex = this.tickets.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialogDelete = true
    },

    deleteItemConfirm () {
      this.tickets.splice(this.editedIndex, 1)
      this.closeDelete()
    },

    close () {
      this.dialog = false
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      })
    },
    close2 () {
      this.dialog2 = false
      // this.$nextTick(() => {
      //   this.editedItem = Object.assign({}, this.defaultItem)
      //   this.editedIndex = -1
      // })
    },


    closeDelete () {
      this.dialogDelete = false
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      })
    },

    save () {
      let hour = 8 + this.editedItem.online_at_time * 2.5;
      let rel_time = moment.utc(hour*3600*1000).format("HH:mm")
      this.editedItem.online_at = this.editedItem.online_at_date +'T' + rel_time +":00+08:00";
      if (this.editedIndex > -1) {
        Object.assign(this.tickets[this.editedIndex], this.editedItem)
      } else {
        this.editedItem.create_at=moment().utc(true)
        this.tickets.push(this.editedItem)
      }
      this.close()
    },

    bashGen(){
      let id_base = 10
      let staD = moment(this.bashBase.start_date,'YYYY-MM-DD')
      let endD = moment(this.bashBase.end_date,'YYYY-MM-DD')
      let number =  endD.diff(staD,'days')+1
      console.log(staD.format('MM-DD'),endD.format('MM-DD'),number)
      for (let ind=0; ind<number;ind++){
        for ( let pri =0; pri<6;pri++){
          if(this.bashBase.periods[pri] ===true){

            let hour = 8 + pri * 2.5;
            let rel_time = moment.utc(hour*3600*1000).format("HH:mm")
            let rel_moment = staD.add(ind,'days').format('yyyy-MM-DD') +'T' + rel_time +":00+08:00";

            this.tickets.push({
              id: id_base+(ind+1)*100000+pri,
              online_at: rel_moment,
              online_at_date: staD.add(ind,'days'),
              online_at_time: rel_time,
              room: this.bashBase.room,
              movie: this.bashBase.movie,
              create_at: moment().utc(true),
              normal_price: this.bashBase.normal_price,
              vip_price:  this.bashBase.vip_price
            })
          }
        }
      }
      this.dialog2=false;
    }
  },
}


</script>

<style scoped>

</style>