<template>
    <div v-if="isDrizzleInitialized">

        <table class="table">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Description</th>
                    <th scope="col">Created At</th>
                    <th scope="col">Due Date</th>
                    <th scope="col">Complete</th>
                    <th scope="col">Prize</th>
                    <th scope="col">Remove</th>
                </tr>
            </thead>
            <tbody>
                <TaskRow v-for="(task, index) in tasks" :key="index" :taskID="index.toString()" :task="task" />
            </tbody>
        </table>

    </div>
    <div v-else>
        <p>Loading...</p>
    </div>
</template>

<script>
import { mapGetters } from 'vuex'
import TaskRow from './TaskRow'

const args = {
    contractName: 'Todos',
    method: 'getTasks',
    methodArgs: ''
}

export default {
    name: 'Tasks',
    components: {
        TaskRow
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
    }
}
</script>
