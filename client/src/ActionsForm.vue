<template>
    <div>
        <button @click.prevent="onCompleteSubmit">Complete</button>
        <button @click.prevent="onClearSubmit">Clear</button>
        <input v-model="prizeAmount" placeholder="Prize Amount (Eth)" type="text">
        <button @click.prevent="onSetPrizeSubmit">Set Prize</button>
    </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
    name: 'ActionsForm',
    props: {
        taskID: {
            type: String,
            required: true
        }
    },
    computed: {
        ...mapGetters('drizzle', ['drizzleInstance']),
        ...mapGetters('accounts', ['activeAccount', 'activeBalance'])
    },
    methods: {
        onCompleteSubmit() {
            this.drizzleInstance
                .contracts[this.contractName]
                .methods['setComplete']
                .cacheSend(this.taskID)
        },
        onClearSubmit() {
            this.drizzleInstance
                .contracts[this.contractName]
                .methods['clear']
                .cacheSend(this.taskID)
        },
        onSetPrizeSubmit() {
            this.drizzleInstance
                .contracts[this.contractName]
                .methods['setPrize']
                .cacheSend(this.taskID, {
                    from: this.activeAccount,
                    value: this.drizzleInstance.web3
                        .utils.toWei(this.prizeAmount,'ether')
                })
        }
    },
    data: () => ({
        contractName: 'Todos',
        prizeAmount: '',
    })
}
</script>
