<template>
    <form>
        <input v-model="taskID" placeholder="Task ID" type="text">
        <input v-model="prizeAmount" placeholder="Prize Amount (Eth)" type="text">
        <button @click.prevent="onSubmit">Submit</button>
    </form>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
    name: 'SetPrizeForm',
    // props: {
    //     taskID: {
    //         type: String,
    //         default: () => ''
    //     }
    // },
    computed: {
        ...mapGetters('drizzle', ['drizzleInstance']),
        ...mapGetters('accounts', ['activeAccount', 'activeBalance'])
    },
    methods: {
        onSubmit() {
            this.drizzleInstance
                .contracts['Todos']
                .methods['setPrize']
                .cacheSend(this.taskID, {
                    from: this.activeAccount,
                    value: this.drizzleInstance.web3
                        .utils.toWei(this.prizeAmount,'ether')
                })
        }
    },
    data: () => ({
        taskID: '',
        prizeAmount: '',
    })
}
</script>
