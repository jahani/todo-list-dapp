<template>
  <div v-if="isDrizzleInitialized">
    <div>
      <drizzle-contract
        contractName="Todos"
        method="getPrize"
        label="Prizes Value"
        units="Ether" :precision="3"
      />

      <drizzle-contract-form
        contractName="Todos"
        method="withdrawPrize"
        :placeholders="['Amount to withdraw']"
      />
    </div>
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Prizes',

  computed: {
    ...mapGetters('drizzle', ['isDrizzleInitialized']),
  }
}
</script>

<style></style>
