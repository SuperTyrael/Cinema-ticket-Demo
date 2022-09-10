<template>
  <div
    v-show="$store.state.loggedIn"
    style="display: flex; width: 100%; height: 100%; align-items: center; justify-content: center; flex-direction: column"
  >
    <div>
      <v-img
        :src="require('@/assets/logo_large.png')"
        max-width="200"
        max-height="200"
      ></v-img>
    </div>
    <h3>{{ generateGreetings() }},Jane Smith</h3>
    <div>Select an item from the left</div>
  </div>
</template>

<script>
import moment from "moment";
export default {
  name: "Default",
  methods: {
    generateGreetings: function() {
      var currentHour = moment().format("HH");

      if (currentHour >= 3 && currentHour < 12) {
        return "Good Morning";
      } else if (currentHour >= 12 && currentHour < 18) {
        return "Good Afternoon";
      } else if (currentHour >= 18 && currentHour < 20) {
        return "Good Evening";
      } else if (currentHour >= 20 || currentHour < 3) {
        return "Good Night";
      } else {
        return "Hello";
      }
    },
  },
};
</script>

<style scoped></style>
