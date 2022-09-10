<template>
  <v-col>
    <v-card class="d-flex" height="12em" width="23em">
      <v-container>
        <v-row>
          <v-col cols="4">
            <v-img contain :aspect-ratio="9 / 16" v-bind:src="pic_src" />
          </v-col>
          <v-col cols="8">
            <v-card-title>
              {{ movie_title }}
              <i
                v-bind:src="get_movie_cert(movie_cert)"
                style="width:1em;height:1em;margin-left:.5em;display:inline"
                v-bind:alt="movie_cert"
              />
            </v-card-title>

            <v-card-text>
              <MovieDetailDialog
                :pic_src="pic_src"
                :movie_title="movie_title"
                :movie_blurb="movie_blurb"
                :movie_cert="movie_cert"
                :movie_director="movie_director"
                :movie_actor="movie_actor"
              />
              <v-btn icon small @click="$emit('edit')">
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
              <v-btn icon small @click="$emit('del')">
                <v-icon>mdi-delete</v-icon>
              </v-btn>
              <span style="font-weight: bold"> Show:  </span><v-switch style="display: inline-block" v-model="movie_enable"></v-switch>
            </v-card-text>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </v-col>
</template>

<script>
import MovieDetailDialog from "@/components/MovieDetailDialog";
export default {
  name: "MovieCard",
  components: { MovieDetailDialog },
  props: [
    "pic_src",
    "movie_title",
    "movie_blurb",
    "movie_cert",
    "movie_director",
    "movie_actor",
    "movie_enable"
  ],
  methods: {
    get_movie_cert: function(movie_cert) {
      return require("@/assets/bbfc/BBFC_" + movie_cert + "_2019.svg");
    },
  },
};
</script>

<style scoped></style>
