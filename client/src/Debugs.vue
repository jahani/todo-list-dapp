<template>
  <div v-if="isDrizzleInitialized">
    <div>

      <h5 class="pt-2">Set a Task as Completed</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="setComplete"
        :placeholders="['Task ID']"
      />
      
      <h5 class="pt-2">Set Prize for a Task</h5>
      <SetPrizeForm />
      
      <h5 class="pt-2">Clear a Task</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="clear"
        :placeholders="['Task ID']"
      />

      <h5 class="pt-2">Remove a Task</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="remove"
        :placeholders="['Task ID']"
      />

      <h5 class="pt-2">Add a Task</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="add"
        :placeholders="['Description', 'Due Date']"
      />

      <h5 class="pt-2">Tasks List</h5>
      <drizzle-contract contractName="Todos" method="getTasks" />

      <h5 class="pt-2">Pause contract deposits</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="pause"
      />

      <h5 class="pt-2">Unpause contract deposits</h5>
      <drizzle-contract-form
        contractName="Todos"
        method="unpause"
      />

    </div>
    
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import SetPrizeForm from './SetPrizeForm'
import { mapGetters } from 'vuex'

export default {
  name: 'Debugs',
  components: {
    SetPrizeForm
  },
  computed: {
    ...mapGetters('drizzle', ['isDrizzleInitialized']),
  }
}
</script>

<style></style>
