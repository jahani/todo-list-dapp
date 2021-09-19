<template>
    <div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Description</th>
                    <th>Created At</th>
                    <th>Due Date</th>
                    <th>Value</th>
                    <th>Completed</th>
                    <th>Cleared</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(task, index) in tasks" :key="index">
                    <td>{{ index }}</td>
                    <td>{{ task.description }}</td>
                    <td>{{ task.createdAt }}</td>
                    <td>{{ task.dueDate }}</td>
                    <td>{{ task.value }}</td>
                    <td>{{ task.completed }}</td>
                    <td>{{ task.cleared }}</td>
                </tr>
            </tbody>
        </table>

    </div>
</template>

<script>
import { mapGetters } from 'vuex'

const args = {
    contractName: 'Todos',
    method: 'getTasks',
    methodArgs: ''
}

export default {
    name: 'Tasks',
    computed: {
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
