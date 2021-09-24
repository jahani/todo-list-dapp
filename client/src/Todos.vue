<template>
  <div v-if="isDrizzleInitialized">
    <div>

      <h5>Set a Task as Completed</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="setComplete"
        :placeholders="['Task ID']"
      />

      
      <h5>Set Prize for a Task</h5>
      <!-- <drizzle-contract-form
        contractName="Todos"
        method="setPrize"
        :placeholders="['Task ID']"
      /> -->
      <SetPrizeForm />

      
      <h5>Clear a Task</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="clear"
        :placeholders="['Task ID']"
      />

    </div>
    
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import Tasks from './Tasks'
import SetPrizeForm from './SetPrizeForm'
import { mapGetters } from 'vuex'

export default {
  name: 'Todos',
  components: {
    Tasks,
    SetPrizeForm
  },
  computed: {
    ...mapGetters('drizzle', ['isDrizzleInitialized']),

    placeholders() {
      return ['Description', 'Due Date']
    }
  }
}
</script>

<style></style>
