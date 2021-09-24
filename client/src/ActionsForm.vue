<template>
    <div>
        <td>
            <div class="d-flex flex-row">
                <b-button size="sm" variant="success" @click.prevent="onCompleteSubmit">Complete</b-button>
                &nbsp;
                <b-button size="sm" variant="primary" @click.prevent="onClearSubmit">Clear</b-button>
                &nbsp;
                <div class="row">
                    <div class="col-md-6 col-sm-12">
                        <b-input size="sm" v-model="prizeAmount" placeholder="Prize Amount (Eth)" type="text" />
                    </div>
                    <div class="col-md-6 col-sm-12">
                        <b-button size="sm" variant="danger" @click.prevent="onSetPrizeSubmit">Set Prize</b-button>
                    </div>
                </div>
            </div>
        </td>
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
