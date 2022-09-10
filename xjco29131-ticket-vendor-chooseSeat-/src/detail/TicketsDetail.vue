<template>
  <div style="width:100%">
    <v-container class="ma-2">
      <v-row>
        <v-col>
          <h2>Tickets</h2>
        </v-col>
        <v-spacer></v-spacer>
        <v-btn>Edit</v-btn>
      </v-row>
      <v-divider></v-divider>
    </v-container>
    <v-container class="ma-5">
      <v-card v-for="ticket in tickets" :key="ticket.id" >
        <v-container class="ma-2">
          <v-row>
            <v-col><h4>Id: </h4>{{ticket.id}}</v-col>
            <v-col><h4>User: </h4><a href="/#/Accounts/detail/10">{{ticket.user}}</a></v-col>
            <v-col><h4>Category:</h4> {{ticket.category}}</v-col>
          </v-row>
          <v-row>
            <v-col><h4>Create: </h4>{{ticket.create_time}}</v-col>
            <v-col><h4>Session: </h4>{{ticket.session}}</v-col>
            <v-col></v-col>
          </v-row>
        </v-container>
      </v-card>
    </v-container>
  </div>
</template>

<script>
export default {
  name: "TicketsDetail",
  data: () => ({
    tickets:[
      {
        id: 12,
        user: 3,
        category:"normal",
        create_time: "March 22nd 2021, 6:24:29",
        pay_time: "March 22nd 2021, 6:24:29",
        pay_method: "cash offline",
        price: 0,
        session: 0,
    },
    {
      id: 12,
      user: 3,
      category:"normal",
      create_time: "March 22nd 2021, 6:24:29",
      pay_time: "March 22nd 2021, 6:24:29",
      pay_method: "cash offline",
      price: 0,
      session: 0,
    }

    ],
  })
}
</script>

<style scoped>

</style>