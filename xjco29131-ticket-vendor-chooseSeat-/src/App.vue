<template>
  <v-app>
    <v-navigation-drawer
      v-if="$store.state.loggedIn"
      app
      v-model="showNav"
      color="#292c35"
      dark
    >
      <v-list-item>
        <v-list-item-content>
          <div style="width: 100%; display: flex">
            <div style="width: 3% ;height: 5px"></div>
            <v-img
              max-width="70%"
              :src="require('@/assets/logo_ho.png')"
            ></v-img>
          </div>
          <v-list-item-title class="title">
            Movie Admin Panel
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>

      <v-divider></v-divider>

      <v-list-item two-line>
        <v-list-item-avatar>
          <img
            src="https://randomuser.me/api/portraits/women/81.jpg"
            alt="avatar"
          />
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title>Jane Smith</v-list-item-title>
          <v-list-item-subtitle>Super Admin</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>

      <v-divider></v-divider>

      <v-list-item-group dense nav v-model="selectedItem">
        <v-list-item
          v-for="item in items"
          :key="item.title"
          link
          :to="item.title | find_route"
          active-class="active-list-item"
        >
          <v-list-item-icon>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>
              {{ item.title }}
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item link to="/logout">
          <v-list-item-icon>
            <v-icon>mdi-logout</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>
              Logout
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-navigation-drawer>

    <v-app-bar app flat color="white">
      <v-app-bar-nav-icon
        v-if="$store.state.loggedIn"
        @click="showNav = !showNav"
      >
      </v-app-bar-nav-icon>

      <v-btn icon class="mr-1">
        <v-icon>mdi-cog</v-icon>
      </v-btn>
      <v-chip dark>{{ currentTime }}</v-chip>
      <v-spacer></v-spacer>
      <v-chip v-if="$store.state.loggedIn" color="white" large>
        <v-avatar left>
          <img
            src="https://randomuser.me/api/portraits/women/81.jpg"
            alt="avatar"
          />
        </v-avatar>
        <div>Jane Smith</div>
      </v-chip>
    </v-app-bar>
    <v-divider></v-divider>

    <v-main style="background-color: #f2f3f8">
      <router-view></router-view>
    </v-main>

    <v-dialog v-model="loginDialog" max-width="400px" persistent>
      <v-card>
        <v-card-title>
          <span class="headline">Login</span>
        </v-card-title>
        <v-card-subtitle>
          You need to be authenticated to view this page.
        </v-card-subtitle>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col>
                <v-text-field
                  label="User Name"
                  prepend-icon="mdi-account"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col>
                <v-text-field
                  type="password"
                  label="Password"
                  prepend-icon="mdi-lock"
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="login">
            Login
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-app>
</template>

<script>
import moment from "moment";

export default {
  name: "App",
  methods: {
    updateCurrentTime() {
      this.currentTime = moment().format("HH:mm:ss");
    },
    login() {
      setTimeout(() => {
        this.$store.dispatch("login");
        this.loginDialog = false;
      }, 1000);
    },
  },
  created() {
    this.currentTime = moment().format("HH:mm:ss");
    setInterval(() => this.updateCurrentTime(), 1000);
  },
  data: () => ({
    selectedItem: 1,
    movies_page: 1,
    currentTime: null,
    showNav: true,
    items: [
      { title: "Tickets", icon: "mdi-ticket" },
      { title: "Movies", icon: "mdi-movie" },
      { title: "Accounts", icon: "mdi-account-cog" },
      { title: "Cinemas", icon: "mdi-theater" },
      { title: "Orders", icon: "mdi-currency-usd" },
      { title: "Venues", icon: "mdi-clock-outline" },
      { title: "Analysis", icon: "mdi-chart-box-outline" },
    ],
    loginDialog: true,
  }),

  filters: {
    find_route: function(title) {
      return "/" + title;
    },
  },
};
</script>

<style scoped>
.active-list-item {
  color: white !important;
  /*font-family: serif;*/
}
</style>
