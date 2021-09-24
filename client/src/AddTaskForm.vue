<template>
    <div v-if="isDrizzleInitialized">

        <div>
            <b-form inline>
                <label class="sr-only" for="inline-form-input-name">Description</label>
                <b-form-input
                v-model="description"
                id="inline-form-input-name"
                class="mb-2 mr-sm-2 mb-sm-0"
                placeholder="Task Description"
                ></b-form-input>

                <label class="sr-only" for="inline-form-input-date">Date</label>
                <b-form-input placeholder="YYYY-MM-DD" type="date" id="inline-form-input-date" v-model="date" class="mb-2"></b-form-input>

                <label class="sr-only" for="inline-form-input-time">Time</label>
                <b-form-input type="time" id="inline-form-input-time" v-model="time" class="mb-2"></b-form-input>

                <b-button @click.prevent="onSubmit" variant="primary">Add</b-button>
            </b-form>
        </div>

    </div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment-timezone'

const args = {
    contractName: 'Todos',
    method: 'add',
    methodArgs: ['_description', '_dueDate']
}

export default {
    name: 'AddTaskForm',
    components: {},
    computed: {
        ...mapGetters('drizzle', ['drizzleInstance', 'isDrizzleInitialized']),
    },
    methods: {
        onSubmit() {
            moment.tz.setDefault();
            let datetimeString = this.date + " " + this.time;
            let timestamp = moment(datetimeString, "YYYY-MM-DD HH:mm").unix();
            this.drizzleInstance
                .contracts[args.contractName]
                .methods[args.method]
                .cacheSend(this.description, timestamp);
        }
    },
    data: () => ({
        description: '',
        date: '',
        time: '',
    })
}
</script>
