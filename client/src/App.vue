<template>
  <div v-if="isDrizzleInitialized" id="app">
    <img alt="Vue logo" src="./assets/logo.png" />

    <div class="section">
      <h2>Show the Accounts</h2>
      <drizzle-account units="Ether" :precision="3" />
    </div>

    <div class="section">
      <h2>Prizes</h2>
      <Prizes />
    </div>

    <div class="section">
      <h2>Todos</h2>
      <Todos />
    </div>

  </div>

  <div v-else>Loading...</div>
</template>

<script>
import Todos from './Todos'
import Prizes from './Prizes'
import { mapGetters } from 'vuex'

export default {
  name: 'app',
  components: {
    Todos,
    Prizes,
  },

  computed: mapGetters('drizzle', ['isDrizzleInitialized'])
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
