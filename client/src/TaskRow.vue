<template>
    <tr>
        <th scope="row">{{ taskID }}</th>
        <td>{{ task.description }}</td>
        <td>{{ beautyDatetime(task.createdAt) }}</td>
        <td>{{ beautyDatetime(task.dueDate) }}</td>
        <td>
            <div v-if="task.completed" style="white-space: nowrap;">
                <b-form-checkbox v-model="task.completed" disabled>
                    &nbsp;Completed
                </b-form-checkbox>
            </div>
            <div v-else>
                <!-- <b-form-checkbox v-model="task.completed" @change="onCompleteSubmit">
                    &nbsp;Complete
                </b-form-checkbox> -->
                <b-button
                    size="sm" @click.prevent="onCompleteSubmit"
                    :variant="task.value!='0' ? 'warning' : 'success'"
                >
                    Complete
                </b-button>
            </div>
        </td>
        <td>
            <span v-if="task.value != '0'">{{ prizeValueString(task.value) }}</span>
            <div v-else-if="task.dueDate != '0' && task.completed == '0'" class="row">
                <b-form inline class="row" @submit.prevent="onSetPrizeSubmit">
                    <div class="col-md-7 col-sm-12">
                        <b-input size="sm" v-model="prizeAmount" placeholder="Amount (Ξ)" type="text" />
                    </div>
                    <div class="col-md-5 col-sm-12">
                        <b-button size="sm" variant="warning" type="submit">Set Prize</b-button>
                    </div>
                </b-form>
            </div>
        </td>
        <td>
            <b-button v-if="task.cleared" size="sm" variant="danger" @click.prevent="onRemoveSubmit">Remove</b-button>
            <b-button v-else size="sm" variant="primary" @click.prevent="onClearSubmit">Clear</b-button>
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
        doAction(_method) {
            this.drizzleInstance
                .contracts[this.contractName]
                .methods[_method]
                .cacheSend(this.taskID)
        },
        onCompleteSubmit() {
            const method = 'setComplete';
            this.doAction(method);
        },
        onClearSubmit() {
            const method = 'clear';
            this.doAction(method);
        },
        onRemoveSubmit() {
            const method = 'remove';
            this.doAction(method);
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
            const m = moment(timestamp*1000);
            const mAbsolute = m.format('YYYY/MM/DD HH:mm:ss');
            const mDiff = m.fromNow();
            return `${mAbsolute} (${mDiff})`;
        }
    },
    data: () => ({
        contractName: 'Todos',
        prizeAmount: '',
    })
}
</script>
