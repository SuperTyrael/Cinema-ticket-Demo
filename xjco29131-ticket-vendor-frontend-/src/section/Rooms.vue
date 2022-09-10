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
        <v-toolbar-title>Room</v-toolbar-title>
        <v-divider
            class="mx-4"
            inset
            vertical
        ></v-divider>
        <v-spacer></v-spacer>
        <v-btn to="/Rooms/edit/12">New Room</v-btn>
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
    <template v-slot:item.pay_at_time="{ item }">
      {{item.pay_at|to_normal_datetime}}
    </template>


    <template v-slot:item.id="{ item }">
      <router-link to="./Rooms/detail/11">{{item.id}}</router-link>
    </template>

    <template v-slot:item.actions="{ item }">
      <v-btn
          icon
          x-small
          class="mr-2"
          to="./Rooms/edit/12"
      >
        <v-icon>mdi-pencil</v-icon>
      </v-btn>

      <v-btn
          icon
          x-small
          color="error"
          @click="deleteItem(item)"
      >
        <v-icon>mdi-delete</v-icon>
      </v-btn>
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
  name: "Tickets",
  data: () => ({
    dialog: false,
    dialogDelete: false,
    headers: [
      { text: 'Id', value: 'id' },
      { text: 'Name', value: 'name' },
      { text: 'Location', value: 'location' },
      { text: 'Create Time', value: 'create_at_time' },
      { text: 'Actions', value: 'actions', sortable: false },
    ],
    tickets: [],
    editedIndex: -1,
    editedItem: {
      id : 0,
      name: "Room 0",
      Location: "local",
      create_at: "2020-01-01T00:00:00+08:00",
    },
    defaultItem: {
      id : 0,
      name: "Room 0",
      Location: "local",
      create_at: "2020-01-01T00:00:00+08:00",
    },
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
          id : 0,
          name: "Zhongying Room 0",
          location: "中影星美国际影城（犀浦百伦店)",
          create_at: "2021-04-21T12:13:33+08:00",
        },
        {
          id : 1,
          name: "CGV Room 0",
          location: "CGV影城（犀浦IMAX店）",
          create_at: "2021-04-21T12:15:32+08:00",
        },
        {
          id : 2,
          name: "Pacific Longcheng Room 0",
          location: "太平洋影城（龙城国际店）",
          create_at: "2021-04-22T14:18:44+08:00",
        },
        {
          id : 3,
          name: "Jialai Room 0",
          location: "嘉莱国际影城（金科路店）",
          create_at: "2021-04-22T14:20:34+08:00",
        },
        {
          id : 4,
          name: "Pacific Jinquan Room 0",
          location: "太平洋影城（金泉店）",
          create_at: "2021-04-22T14:25:45+08:00",
        },
        {
          id : 5,
          name: "SFC Room 0",
          location: "SFC上影影城（成都龙湖IMAX店）",
          create_at: "2021-04-22T14:34:21+08:00",
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

    closeDelete () {
      this.dialogDelete = false
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      })
    },

    save () {
      if (this.editedIndex > -1) {
        Object.assign(this.tickets[this.editedIndex], this.editedItem)
      } else {
        this.tickets.push(this.editedItem)
      }
      this.close()
    },
  },
}

</script>
