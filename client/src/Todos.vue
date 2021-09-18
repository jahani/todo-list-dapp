<template>
  <div v-if="isDrizzleInitialized">
    <div>

      <h3>Tasks List</h3>
      <b>Description / Created At / Value / Due Date / Compeleted / Cleared</b>
      <drizzle-contract contractName="Todos" method="getTasks" />

      <!-- <drizzle-contract
        contractName="Todos"
        method="getPrize"
        label="Value"
      /> -->

      <h3>Add a Task</h3>
      <drizzle-contract-form
        contractName="Todos"
        method="add"
        :placeholders="placeholders"
      />


      <h3>Set a Task as Completed</h3>
      <drizzle-contract-form
        contractName="Todos"
        method="setComplete"
        :placeholders="['Task ID']"
      />

      <h3>Set Prize for a Task</h3>
      <drizzle-contract-form
        contractName="Todos"
        method="setPrize"
        :placeholders="['Task ID']"
      />
      
      <h3>Clear a Task</h3>
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
import { mapGetters } from 'vuex'

export default {
  name: 'Todos',

  computed: {
    ...mapGetters('drizzle', ['isDrizzleInitialized']),

    placeholders() {
      return ['Description', 'Due Date']
    }
  }
}
</script>

<style></style>
