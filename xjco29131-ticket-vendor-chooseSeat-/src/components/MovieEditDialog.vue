<template>
  <v-dialog
      v-model="dialog"
      width="70em"
  >
    <template v-slot:activator="{ on, attrs }">
      <v-btn
          v-bind="attrs"
          v-on="on"
          small
          icon
      >
        <v-icon>mdi-information</v-icon>
      </v-btn>
    </template>

    <v-card>
      <v-container>
        <v-row>
          <v-col cols="3">
            <v-img v-bind:src="pic_src"/>
          </v-col>
          <v-col cols="9">
            <v-card-title class="display-1">
              {{ movie_title }}
              <img v-bind:src="get_movie_cert(movie_cert)"
                   style="width:1em;height:1em;margin-left:.5em "
                   v-bind:alt="movie_cert"
              />
            </v-card-title>
            <v-card-text class="font-weight-bold">
              Director: {{movie_director}} <br/>
              Actor: {{movie_actor_1}} / {{movie_actor_2}}
            </v-card-text>
            <v-card-text>
              {{ movie_blurb }}
            </v-card-text>
            <v-card-text>
              <v-btn
                  @click="dialog=false"
              >Ok</v-btn>
            </v-card-text>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </v-dialog>
</template>

<script>

export default {
  name: "EditDialog",
  data: () => ({
    dialog: false,
  }),
  props:['have_pic','',
  '','movie_blurb','movie_cert','movie_director','movie_actor_1','movie_actor_2'],
  methods: {
    get_movie_cert: function (movie_cert) {
      return require("@/assets/bbfc/BBFC_"+movie_cert+"_2019.svg");
    }
  }
}
</script>

<style scoped>

</style>