<template>
  <div v-if="isDrizzleInitialized" id="app">
    <div>
      <b-navbar type="dark" variant="dark" sticky>
        <div class="container">
        
          <b-navbar-brand href="#">
            <img src="./assets/logo.png" width="30" height="30" class="d-inline-block align-top" alt="Kitten">
            Todo List DApp
          </b-navbar-brand>

          <b-navbar-nav>
            <b-nav-item href="#">Home</b-nav-item>
          </b-navbar-nav>

          <b-navbar-nav>
            <b-nav-item href="#" disabled>
              <drizzle-account units="Ether" :precision="3" />
            </b-nav-item>
          </b-navbar-nav>

        </div>
      </b-navbar>
    </div>

    <div class="container">

      <div class="row">
        <div class="col-lg-6 col-sm-12">
          <h3>Add a Task</h3>
          <drizzle-contract-form
            contractName="Todos"
            method="add"
            :placeholders="['Description', 'Due Date']"
          />
        </div>
        <div class="col-lg-6 col-sm-12">
          <h3>Prizes</h3>
          <Prizes />
        </div>
      </div>

      <div class="row">
        <div class="col-sm-12">
          <h3>Todos</h3>
          <!-- <drizzle-contract contractName="Todos" method="getTasks" /> -->
          <Tasks />
        </div>
      </div>

      <div class="row">
        <Todos />
      </div>

    </div>

  </div>

  <div v-else>
    <p>Loading...</p>
    <p>Is MetaMask extension installed on your browser?</p>
  </div>
</template>

<script>
import Todos from './Todos'
import Tasks from './Tasks'
import Prizes from './Prizes'
import { mapGetters } from 'vuex'

export default {
  name: 'app',
  components: {
    Todos,
    Tasks,
    Prizes,
  },

  computed: mapGetters('drizzle', ['isDrizzleInitialized'])
}
</script>

<style>
#app {
  /* font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px; */
}
</style>
