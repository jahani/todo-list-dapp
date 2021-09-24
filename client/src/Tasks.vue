<template>
    <div v-if="isDrizzleInitialized">

        <table class="table">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Description</th>
                    <th scope="col">Created At</th>
                    <th scope="col">Due Date</th>
                    <th scope="col">Value</th>
                    <th scope="col">Completed</th>
                    <th scope="col">Cleared</th>
                    <th scope="col"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(task, index) in tasks" :key="index">
                    <th scope="row">{{ index }}</th>
                    <td>{{ task.description }}</td>
                    <td>{{ beautyDatetime(task.createdAt) }}</td>
                    <td>{{ beautyDatetime(task.dueDate) }}</td>
                    <td>{{ prizeValueString(task.value) }}</td>
                    <td>{{ task.completed }}</td>
                    <td>{{ task.cleared }}</td>
                    <td><ActionsForm :taskID="index.toString()" /></td>
                </tr>
            </tbody>
        </table>

    </div>
    <div v-else>
        <p>Loading...</p>
    </div>
</template>

<script>
import { mapGetters } from 'vuex'
import ActionsForm from './ActionsForm'
import moment from 'moment'

const args = {
    contractName: 'Todos',
    method: 'getTasks',
    methodArgs: ''
}

export default {
    name: 'Tasks',
    components: {
        ActionsForm
    },
    computed: {
        ...mapGetters('drizzle', ['drizzleInstance', 'isDrizzleInitialized']),
        ...mapGetters('contracts', ['getContractData']),
        rawTasks() {
            return this.getContractData({
                contract: args.contractName,
                method: args.method
            });
        },
        tasks() {
            let outputTaks = [...this.rawTasks];
            outputTaks.forEach((task, index, theArray) => {
                theArray[index] =  {
                    'description': task[0],
                    'createdAt': task[1],
                    'value': task[2],
                    'dueDate': task[3],
                    'completed': task[4],
                    'cleared': task[5],
                };
            });
            return outputTaks;
        }
    },
    created() {
        this.$store.dispatch('drizzle/REGISTER_CONTRACT', args)
    },
    methods: {
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
    }
}
</script>
