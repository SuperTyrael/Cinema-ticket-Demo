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
        <v-toolbar-title>Cinema</v-toolbar-title>
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
                      cols="12"
                      sm="4"
                  >
                    <v-text-field
                        v-model="editedItem.user_id"
                        label="User"
                    ></v-text-field>
                  </v-col>
                  <v-col
                      cols="12"
                      sm="4"
                  >
                    <v-text-field
                        v-model="editedItem.price"
                        label="price"
                        type="number"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col
                      cols="12"
                      sm="4"
                  >
                    <v-text-field
                        v-model="editedItem.session_id"
                        label="Session"
                    ></v-text-field>
                  </v-col>
                  <v-col
                      cols="12"
                      sm="8"
                  >
                    <v-text-field
                        v-model="editedItem.pay_method"
                        label="Pay Method"
                    ></v-text-field>
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
                  @click="save"
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
    <template v-slot:item.pay_at_time="{ item }">
      {{item.pay_at|to_normal_datetime}}
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
  name: "Tickets",
  data: () => ({
    dialog: false,
    dialogDelete: false,
    headers: [
      { text: 'Id', value: 'id' },
      { text: 'User', value: 'user' },
      { text: 'Category', value: 'category' },
      { text: 'Create Time', value: 'create_at_time' },
      { text: 'Pay at', value: 'pay_at_time' },
      { text: 'Pay Method', value: 'pay_method' },
      { text: 'Price', value: 'price' },
      { text: 'Session', value: 'session' },
      { text: 'Actions', value: 'actions', sortable: false },
    ],
    tickets: [],
    editedIndex: -1,
    editedItem: {
      id : 0,
      user_id: 0,
      category: "normal",
      create_at: "2020-01-01T00:00:00+08:00",
      pay_at: "2020-01-01T00:00:00+08:00",
      pay_method: "cash offline",
      price: 0,
      session_id: 0,
    },
    defaultItem: {
      id : 0,
      user_id: 0,
      category: "normal",
      create_time: "2020-01-01T00:00:00+08:00",
      pay_time: "2020-01-01T00:00:00+08:00",
      pay_method: "cash offline",
      price: 0,
      session_id: 0,
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
          user_id: 0,
          category: "normal",
          create_time: "2020-01-01T00:00:00+08:00",
          pay_time: "2020-01-01T00:00:00+08:00",
          pay_method: "cash offline",
          price: 0,
          session_id: 0,
        },
        {
          id : 1,
          user_id: 0,
          category: "normal",
          create_time: "2020-01-01T00:00:00+08:00",
          pay_time: "2020-01-01T00:00:00+08:00",
          pay_method: "cash offline",
          price: 0,
          session_id: 0,
        },
        {
          id : 2,
          user_id: 0,
          category: "normal",
          create_time: "2020-01-01T00:00:00+08:00",
          pay_time: "2020-01-01T00:00:00+08:00",
          pay_method: "cash offline",
          price: 0,
          session_id: 0,
        },
        {
          id : 3,
          user_id: 0,
          category: "normal",
          create_time: "2020-01-01T00:00:00+08:00",
          pay_time: "2020-01-01T00:00:00+08:00",
          pay_method: "cash offline",
          price: 0,
          session_id: 0,
        },
        {
          id : 4,
          user_id: 0,
          category: "child",
          create_time: "2020-01-01T00:00:00+08:00",
          pay_time: "2020-01-01T00:00:00+08:00",
          pay_method: "cash offline",
          price: 0,
          session_id: 0,
        },
        {
          id : 5,
          user_id: 0,
          category: "normal",
          create_time: "2020-01-01T00:00:00+08:00",
          pay_time: "2020-01-01T00:00:00+08:00",
          pay_method: "cash offline",
          price: 0,
          session_id: 0,
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

<style scoped>

</style>