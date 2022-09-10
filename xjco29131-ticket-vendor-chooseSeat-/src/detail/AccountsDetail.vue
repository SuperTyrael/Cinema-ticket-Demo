<template>
  <v-container class="ma-2">
    <v-row>
      <v-col>


        <h2>User</h2>
      </v-col>
      <v-spacer></v-spacer>
      <v-btn>Edit</v-btn>
    </v-row>
    <v-divider></v-divider>
    <v-row>
      <v-col><h4>Id: </h4>{{id}}</v-col>
    </v-row>
    <v-row>
      <v-col><h4>Email: </h4>{{email}}</v-col>
    </v-row>
    <v-row>
      <v-col><h4>Mobile: </h4>{{mobile}}</v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "AccountsDetail",
  data: () => ({
    id : 3,
    email: 'example@example.com',
    mobile: "18900001219",
    create_at: "2020-01-01T00:00:00+08:00",
  })
}
</script>

<style scoped>


</style>