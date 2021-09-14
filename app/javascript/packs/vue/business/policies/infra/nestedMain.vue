<template lang="pug">
  draggable.dragArea.w-100(
  v-bind="dragOptions"
  tag="table"
  :list="policies"
  ghost-class="alert-secondary"
  @change="movePolicy"
  )
    template(v-for='(el, idxEl) in policies')
      tbody
        .table__row
          .table__cell.table__cell_name.table__cell_first
            router-link.link(:to='`/business/compliance_policies/${el.id}`') {{ el.title }}
          .table__cell(v-if="!shortTable && el.status")
            b-badge.status(:variant="statusVariant(el.status)") {{ el.status }}
          .table__cell.text-right(v-if="!shortTable && el.updated_at") {{ dateToHuman(el.updated_at) }}
          .table__cell.text-right(v-if="!shortTable && el.created_at") {{ dateToHuman(el.created_at) }}
          .table__cell(v-if="!shortTable && el.created_at")
            .actions
              b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                template(#button-content)
                  b-icon(icon="three-dots")
                router-link.dropdown-item(v-if="!el.archived" :to='`/business/compliance_policies/${el.id}`') Edit
                b-dropdown-item(v-if="!el.archived" @click="moveUp(el.id)") Move up
                PoliciesModalArchive(v-if="!el.archived" @saved="updateList", :policyId="el.id", :archiveStatus="!el.archived" @archiveConfirmed="archivePolicy(el.id, !el.archived)" :inline="false")
                  b-dropdown-item Archive
                b-dropdown-item(v-if="el.archived" @click="archivePolicy(el.id, !el.archived)") Unarchive
                PoliciesModalDelete(@saved="updateList", :policyId="el.id", @deleteConfirmed="deletePolicy(el.id)" :inline="false")
                  b-dropdown-item.delete Delete
        .dropdown-items(v-if="el.children && el.children.length" :id="`#section-${el.id ? el.id : idxEl+'_'+randomNum}`" :class="{active : shortTable}")
          nested-draggable(
          v-show="open"
          :list="el.children"
          :policy="el"
          :policyId="el.id ? el.id : parentSection.id"
          :policyTitle="el.title"
          :parentSection="el"
          :policiesList="policiesList"
          :shortTable="shortTable"
          )
</template>
<script>
  import draggable from "vuedraggable";
  import { DateTime } from 'luxon'
  import PoliciesModalDelete from "../Modals/PoliciesModalDelete";
  import PoliciesModalArchive from "../Modals/PoliciesModalArchive";
  export default {
    props: {
      value: {
        required: false,
        type: Array,
        default: null
      },
      list: {
        required: false,
        type: Array,
        default: null
      },
      policiesList: {
        required: false,
        type: Array,
        default: null
      },
      policy: {
        required: false,
        type: Object,
        default: null
      },
      policyTitle: {
        required: false,
        type: String,
        default: null
      },
      policyId: {
        required: false,
        type: Number,
        default: null
      },
      parentSection: {
        required: false,
        type: Object,
        default: null
      },
      shortTable: {
        required: false,
        type: Boolean,
        default: false
      },
    },
    name: "nested-draggable",
    components: {
      draggable,
      PoliciesModalDelete,
      PoliciesModalArchive
    },
    data() {
      return {
        sections: [],
        children: [],
        policies: [],
        originalPosition: [],
        draggedContext: {},
        relatedContext: {},
        open: true,
        randomNum: 0
      }
    },
    methods: {
      statusVariant(str_status) {
        switch(str_status) {
          case 'published':
            return 'success'
            break;
          case 'archived':
            return 'danger'
            break
          case 'draft':
            return 'light'
            break
          default:
            return 'light'
        }
      },
      updateList () {
        this.$store
          .dispatch("getPolicies")
          .then((response) => {
            //console.log(response);
          })
          .catch((error) => {
            console.error(error);
            this.toast('Error', err.message, true)
          });
      },
      movePolicy(evt) {
        const positionChange = []
        for(let i = 0; i < this.originalPosition.length; i++) {
          const item = this.policies[i]
          item.position = this.originalPosition[i]
          this.$set(this.policies, i, item)
          positionChange.push({id: item.id, position: item.position})
        }

        this.$store
          .dispatch("updatePolicyPositions", {
            positionChange: positionChange
          })
          .then((response) => {
            console.log('response in nested', response)
          })
          .catch((error) => {
            console.error(error)
            this.toast('Error', err.message, true)
          })
      },
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('MM/dd/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      
      deletePolicy(policyId) {
        this.$store
          .dispatch('deletePolicyById', { policyId })
          .then(response => {
            //console.log('response', response)
            this.toast('Success', `Policy has been deleted.`)
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Policy has not been deleted. Please try again. ${error}`, true)
          })
      },
      archivePolicy(policyId, archiveStatus) {
        this.$store
          .dispatch('archivePolicyById', { policyId, archived: archiveStatus })
          .then(response => {
            this.$store.commit('updatePolicy', response)
            this.toast('Success', `Policy has been ${archiveStatus ? 'archived' : 'unarchived'}!`)
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Couldn't submit form! ${error}`, true)
          })
      },
      toogleSections(value) {
        //console.log(value)
        // //console.log(document.getElementById(`#section-${value}`))
        document.getElementById(`#section-${value}`).classList.toggle('active');
        document.getElementById(`#sectionIcon-${value}`).classList.toggle('active');
      },
    },
    computed: {
      dragOptions() {
        return {
          animation: 0,
          group: "description",
          disabled: false,
          ghostClass: "ghost"
        };
      },
    },
    mounted() {
      this.randomNum = Math.floor(Math.random() * 100)
      this.policies = this.policiesList
      this.originalPosition = [...this.policiesList].map(item => item.position)
    },
    watch: {
      policiesList: function(newValue) {
        this.policies = newValue
        this.originalPosition = [...newValue].map(item => item.position)
      }
    }
  };
</script>

