<template>
    <div v-if="isDrizzleInitialized">

        <div>
            <b-form inline class="row" @submit.prevent="onSubmit">

                <div class="col-sm-5">
                    <b-form-input
                    v-model="description"
                    class="mb-2"
                    placeholder="Task Description"
                    ></b-form-input>
                </div>

                <div class="col-sm-3">
                    <b-form-input type="date" v-model="date" class="mb-2"></b-form-input>
                </div>

                <div class="col-sm-3">
                    <b-form-input type="time" v-model="time" class="mb-2"></b-form-input>
                </div>

                <div class="col-sm-1">
                    <b-button type="submit" variant="primary">Add</b-button>
                </div>

            </b-form>
        </div>

    </div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'

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
            let timestamp = 0;
            if (this.date != "" && this.time != "") {
                let datetimeString = this.date + " " + this.time;
                timestamp = moment(datetimeString, "YYYY-MM-DD HH:mm").unix();
            }
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
