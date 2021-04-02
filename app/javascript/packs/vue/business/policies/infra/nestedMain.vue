<template lang="pug">
  draggable.dragArea(tag='tbody' :list='policies' :group="{ name: 'g1' }" :move="checkMove" @end="onEnd")
    .table__row(v-for='el in policies' :key='el.title')
      .table__cell.table__cell_name(v-if="el.children && el.children.length !== 0")
        .dropdown-toggle(
          :id="`#nested-sectionIcon-${el.id}`", @click="toogleSections(el.id)"
          :class="[el.children && el.children.length !== 0 ? 'active' : '']"
          )
          b-icon.mr-2(v-if="el.children && el.children.length !== 0" icon="chevron-compact-down")
          b-icon.mr-2(v-else icon="chevron-compact-right")
          | {{ el.title }}
        nested-draggable(:policies="el.children" :policyTitle="el.title" :policiesList="policiesList")
      .table__cell.table__cell_name(v-else) {{ el.title }}
      .table__cell(v-if="el.status")
        .status.status__draft {{ el.status }}
      .table__cell(v-if="el.updated_at") {{ dateToHuman(el.updated_at) }}
      .table__cell(v-if="el.created_at") {{ dateToHuman(el.created_at) }}
      .table__cell(v-if="el.created_at") N/A
      .table__cell(v-if="el.created_at")
        .actions
          button.px-0.actions__btn(:id="`#nested-actionIcon-${el.id}`", @click="toogleActions(el.id)")
            b-icon(icon="three-dots")
          ul.actions-dropdown(:id="`#nested-action-${el.id}`")
            li.actions-dropdown__item.edit
              a.link(:href="'/business/compliance_policies/'+el.id") Edit
            li.actions-dropdown__item.move-up(@click="moveUp(el.id)") Move up
            li.actions-dropdown__item.archive
              PoliciesModalArchive(@saved="updateList", :policyId="el.id", :archiveStatus="!el.archived" @archiveConfirmed="archivePolicy(el.id, !el.archived)") {{ !el.archived ? 'Archive' : 'Unarchive' }}
            li.actions-dropdown__item.delete(v-if="el.archived")
              PoliciesModalDelete(@saved="updateList", :policyId="el.id", @deleteConfirmed="deletePolicy(el.id)") Delete
</template>
<script>
  import draggable from "vuedraggable";
  import { DateTime } from 'luxon'
  import PoliciesModalDelete from "../Modals/PoliciesModalDelete";
  import PoliciesModalArchive from "../Modals/PoliciesModalArchive";
  export default {
    props: ['policies', 'policyTitle', 'policiesList'],
    name: "nested-draggable",
    components: {
      draggable,
      PoliciesModalDelete,
      PoliciesModalArchive
    },
    data() {
      return {
        sections: [],
        draggedContext: {},
        relatedContext: {},
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      updateList () {
        this.$store
          .dispatch("getPolicies")
          .then((response) => {
            console.log(response);
          })
          .catch((err) => {
            console.error(err);
            this.makeToast('Error', err.message)
          });
      },
      movePolicy() {
        const policy = this.policiesList.find(policy => {
          if (policy.id === this.relatedContext.element.id) return policy
        })
        this.$store
          .dispatch("movePolicy", {
            id: this.draggedContext.element.id,
            position: policy.position - 0.01
          })
          .then((response) => {
            console.log('response in nested', response)
            this.makeToast('Success', 'Policy succesfully moved.')
          })
          .catch((err) => {
            console.error(err)
            this.makeToast('Error', err.message)
          });
      },
      checkMove: function(evt){
        console.log('relatedContext', evt.relatedContext)
        console.log('draggedContext:', evt.draggedContext)

        // 1. MOVE ROOT POLICY TO ANOTHER PLACE
        if(!this.policyTitle) {
          this.draggedContext = evt.draggedContext
          this.relatedContext = evt.relatedContext
        }

        // 2. MOVE ROOT POLICY INSIDE ANOTHER POLICY
        if(evt.draggedContext.element.id && !evt.relatedContext.element.id) {
          return false;
        }

        // 3. MOVE Section of POLICY INSIDE this POLICY
        if(this.policyTitle) {
          this.sections = evt.relatedContext.list
        }

        // 4. MOVE Section of POLICY INSIDE another POLICY
        // 5. MOVE Section Child of POLICY INSIDE this POLICY
        // 6. MOVE Section Child of POLICY INSIDE another POLICY
        // 7. MOVE UP Section POLICY INSIDE this POLICY
        // 8. MOVE DOWN Section POLICY INSIDE this POLICY
        // 9. MOVE UP Section Child POLICY INSIDE this POLICY
        // 10. MOVE DOWN Section Child POLICY INSIDE this POLICY
      },
      onEnd(evt){
        console.log('event', evt)

        if (!this.policyTitle) {
          this.movePolicy()
          return
        }

        if(this.policyTitle && this.sections) {
          const policy = this.policiesList.find(policy => policy['title'] === this.policyTitle)

          this.$store.dispatch("updatePolicy", {
            id: policy.id,
            sections: this.sections
          });
        }
      },
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('dd/MM/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      toogleActions(value) {
        document.getElementById(`#nested-action-${value}`).classList.toggle('active');
        document.getElementById(`#nested-actionIcon-${value}`).classList.toggle('active');
      },
      toogleSections(value) {
        document.getElementById(`#nested-section-${value}`).classList.toggle('active');
        document.getElementById(`#nested-sectionIcon-${value}`).classList.toggle('active');
      },
      moveUp(policyId) {
        const index = this.policies.findIndex(record => record.id === policyId);
        const newPos = this.policies[index - 1].position - 0.01

        this.$store
          .dispatch("movePolicy", {
            id: this.policies[index].id,
            position: newPos
          })
          .then((response) => {
            console.log('response', response)
            this.makeToast('Success', 'Policy succesfully moved.')
          })
          .catch((err) => {
            console.error(err)
            this.makeToast('Error', err.message)
          });
      },
      deletePolicy(policyId) {
        this.$store
          .dispatch('deletePolicyById', { policyId })
          .then(response => {
            console.log('response', response)
            this.makeToast('Success', `Policy successfully deleted!`)
          })
          .catch(error => {
            console.error(err)
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
      archivePolicy(policyId, archiveStatus) {
        this.$store
          .dispatch('archivePolicyById', { policyId, archived: archiveStatus })
          .then(response => {
            console.log('response', response)
            this.makeToast('Success', `Policy successfully archived!`)
          })
          .catch(error => {
            console.error(err)
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
    },
    computed: {

    }
  };
</script>
<style scoped>
  .dragArea {
    /*min-height: 50px;*/
    outline: 1px dashed transparent;
    transition: all 200ms ease-in;
  }
  .dragArea:hover,
  .dragArea:active {
    /*height: 50px;*/
    outline-color: #ced4da;
  }
</style>
