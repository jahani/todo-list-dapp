<template>
  <div v-if="isDrizzleInitialized">
    <div>
      <drizzle-contract
        contractName="Todos"
        method="getPrize"
        label="Value"
      />

      <drizzle-contract-form
        contractName="Todos"
        method="add"
        :placeholders="['Value']"
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
