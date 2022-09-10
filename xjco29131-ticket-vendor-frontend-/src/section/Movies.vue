<template>
  <v-container>
    <v-row>
      <v-col>
        <v-toolbar flat>
          <v-container>
            <v-row>
              <v-col>
                <v-text-field
                  single-line
                  prepend-inner-icon="mdi-magnify"
                  label="keyword"
                  name="keyword"
                  v-model="keyword"
                ></v-text-field>
              </v-col>
              <v-col cols="2">
                <v-switch
                  name="on_show"
                  label="on show"
                  v-model="on_show"
                ></v-switch>
              </v-col>
              <v-col>
                <v-select
                  v-model="select"
                  :items="items"
                  :rules="[(v) => !!v || 'Item is required']"
                  label="Order By"
                  required
                ></v-select>
              </v-col>
              <v-col>
                <v-btn type="submit">search</v-btn>
              </v-col>
              <v-col>
                <v-btn
                  color="primary"
                  dark
                  class="mb-2"
                  @click="openNewDialog()"
                >
                  New Movie
                </v-btn>
              </v-col>
            </v-row>
          </v-container>
        </v-toolbar>
      </v-col>
    </v-row>
    <v-row>
      <MovieCard
        v-for="(item, index) in movies"
        v-bind:key="index"
        :pic_src="item.pic_src"
        :movie_title="item.title"
        :movie_cert="item.cert"
        :movie_blurb="item.blurb"
        :movie_director="item.director"
        :movie_actor="item.actor"
        :movie_enable="true"
        @edit="openEditDialog(item)"
      ></MovieCard>
    </v-row>
    <v-row>
      <v-col align-self="center">
        <template>
          <div class="text-center">
            <v-pagination v-model="page" :length="6"></v-pagination>
          </div>
        </template>
      </v-col>
    </v-row>
    <v-dialog v-model="dialog" max-width="800px">
      <v-card>
        <v-card-title>
          <span class="headline">Movie</span>
        </v-card-title>

        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="4">
                <v-img v-bind:src="currentMovie.pic_src" />
                <v-file-input show-size label="Cover"></v-file-input>
              </v-col>
              <v-col>
                <v-row>
                  <v-col>
                    <v-text-field
                      v-model="currentMovie.title"
                      label="Title"
                    ></v-text-field>
                  </v-col>
                  <v-col>
                    <v-text-field
                      v-model="currentMovie.director"
                      label="Director"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col>
                    <v-text-field
                      v-model="currentMovie.actor"
                      label="Actors"
                    ></v-text-field>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col>
                    <v-select
                      :items="certItems"
                      label="BBFC Cert"
                      v-model="currentMovie.cert"
                    ></v-select>
                  </v-col>
                  <v-col>
                    <v-select
                        label="category"
                        :items="cates"
                        v-model="cate_sel"
                    ></v-select>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col>
                    <v-textarea
                      v-model="currentMovie.blurb"
                      auto-grow
                      label="Blurb"
                    ></v-textarea>
                  </v-col>
                </v-row>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">
            Cancel
          </v-btn>
          <v-btn color="blue darken-1" text @click="save">
            Save
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import MovieCard from "@/components/MovieCard";
import cloneDeep from "lodash-es/cloneDeep";

export default {
  name: "Movies",
  components: {
    MovieCard,
  },
  data: () => ({
    cates:["Animation"],
    cate_sel:"Animation",
    on_show: true,
    keyword: "",
    select: 0,
    items: ["Name"],
    page: 1,
    dialog: false,
    currentMovie: {},
    certItems: ["PG", "U", "12", "12A", "15", "18"],
  }),
  computed: {
    movies() {
      return this.$store.state.movies;
    },
  },
  methods: {
    search: function() {
      this.axios({
        method: "post",
        url: "movie.m.reimu.host:8080/guest/films_info",
        data: {
          keyword: this.keywords,
          on_show: this.on_show,
        },
        responseType: "json",
      }).then((response) => {
        this.movies = [];
        for (const item in response.data) {
          if (Object.prototype.hasOwnProperty.call(response.data, item))
            this.movies.push(item);
        }
      });
    },
    openNewDialog() {
      this.currentMovie = {};
      this.dialog = true;
    },
    openEditDialog(movie) {
      this.currentMovie = cloneDeep(movie);
      this.dialog = true;
    },
  },
};
</script>

<style scoped></style>
