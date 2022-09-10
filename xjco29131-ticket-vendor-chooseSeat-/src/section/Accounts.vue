<template>
  <v-data-table
      :headers="headers"
      :items="accounts"
      sort-by="calories"
      class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar
          flat
      >
        <v-toolbar-title>Account</v-toolbar-title>
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
                        v-model="editedItem.id"
                        label="Id"
                    ></v-text-field>
                  </v-col>
                  <v-col
                      cols="12"
                      sm="8"
                  >
                    <v-text-field
                        v-model="editedItem.email"
                        label="Email"
                        type="email"
                        :rules="emailRules"
                        prepend-inner-icon="mdi-email"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col
                      cols="12"
                      sm="8"
                  >
                    <v-text-field
                        v-model="editedItem.mobile"
                        label="Mobile"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col
                      cols="12"
                      sm="8"
                  >
                    <v-text-field
                        v-model="editedItem.password"
                        :append-icon="showpass ? 'mdi-eye' : 'mdi-eye-off'"
                        :type="showpass ? 'text' : 'password'"
                        label="Password"
                        counter
                        @click:append="showpass = !showpass"
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
  name: "Accounts",
  data: () => ({
    dialog: false,
    dialogDelete: false,
    headers: [
      { text: 'Id', value: 'id' },
      { text: 'Email', value: 'email' },
      { text: 'Mobile', value: 'mobile' },
      { text: 'Create Time', value: 'create_at_time' },
      { text: 'Actions', value: 'actions', sortable: false },
    ],
    accounts: [],
    editedIndex: -1,
    editedItem: {
      id : 0,
      email: 'example@example.com',
      mobile: "0",
      password: "",
      create_at: "2020-01-01T00:00:00+08:00",
    },
    defaultItem: {
      id : 0,
      email: 'example@example.com',
      mobile: "0",
      password: "",
      create_at: "2020-01-01T00:00:00+08:00",
    },
    emailRules: [
      v => !!v || 'E-mail is required',
      v => /.+@.+/.test(v) || 'E-mail must be valid',
    ],
    showpass:false,
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
      this.accounts = [
        {
          id : 1,
          email: 'example@example.com',
          mobile: "18900001111",
          password: "0",
          create_at: "2020-01-01T00:00:00+08:00",
        },
        {
          id : 2,
          email: 'example@example.com',
          mobile: "18900001212",
          password: "0",
          create_at: "2020-01-01T00:00:00+08:00",

        },
        {
          id : 3,
          email: 'example@example.com',
          mobile: "18900001219",
          password: "0",
          create_at: "2020-01-01T00:00:00+08:00",
        },
        {
          id : 4,
          email: 'example@example.com',
          mobile: "18900001712",
          password: "0",
          create_at: "2020-01-01T00:00:00+08:00",
        },
        {
          id : 5,
          email: 'example@example.com',
          mobile: "18906001212",
          password: "0",
          create_at: "2020-01-01T00:00:00+08:00",
        },
        {
          id : 6,
          email: 'example@example.com',
          mobile: "0",
          password: "0",
          create_at: "2020-01-01T00:00:00+08:00",
        },
      ]
    },

    editItem (item) {
      this.editedIndex = this.accounts.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialog = true
    },

    deleteItem (item) {
      this.editedIndex = this.accounts.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.dialogDelete = true
    },

    deleteItemConfirm () {
      this.accounts.splice(this.editedIndex, 1)
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
        Object.assign(this.accounts[this.editedIndex], this.editedItem)
      } else {
        this.accounts.push(this.editedItem)
      }
      this.close()
    },
  },
}


</script>

<style scoped>

</style>