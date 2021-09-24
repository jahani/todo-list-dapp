<template>
    <tr>
        <th scope="row">{{ taskID }}</th>
        <td>{{ task.description }}</td>
        <td>{{ beautyDatetime(task.createdAt) }}</td>
        <td>{{ beautyDatetime(task.dueDate) }}</td>
        <td>
            <span v-if="task.completed">✅</span>
            <b-button v-else size="sm" variant="primary" @click.prevent="onCompleteSubmit">Check</b-button>
        </td>
        <td>
            <span v-if="task.value != '0'">{{ prizeValueString(task.value) }}</span>
            <div v-else class="row">
                <div class="col-md-6 col-sm-12">
                    <b-input size="sm" v-model="prizeAmount" placeholder="Prize Amount (Eth)" type="text" />
                </div>
                <div class="col-md-6 col-sm-12">
                    <b-button size="sm" variant="danger" @click.prevent="onSetPrizeSubmit">Set Prize</b-button>
                </div>
            </div>
        </td>
        <td>
            <b-button v-if="!task.cleared" size="sm" variant="primary" @click.prevent="onClearSubmit">Clear</b-button>
            <span v-else>-</span>
        </td>
    </tr>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'

export default {
    name: 'TaskRow',
    props: {
        taskID: String,
        task: Object
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
        },
        prizeValueString(_valueInWei) {
            const web3 = this.drizzleInstance.web3;
            const valueInWei = new web3.utils.BN(_valueInWei);
            if (valueInWei.toString() == '0') {
                    return '-';
            }
            return web3.utils.fromWei(valueInWei) + ' Ξ';
        },
        beautyDatetime(timestamp) {
            if (timestamp == 0 || timestamp == '0') {
                return "-";
            }
            return moment(timestamp*1000).format('YYYY/MM/DD HH:mm:ss');
        }
    },
    data: () => ({
        contractName: 'Todos',
        prizeAmount: '',
    })
}
</script>
