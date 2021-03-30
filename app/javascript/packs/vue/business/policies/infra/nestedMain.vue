<template lang="pug">
  draggable.table.dragArea(tag='div' :list='policies' :group="{ name: 'g1' }" :move="checkMove")
    .table__row(v-for='(el, indexEl) in policies' :key='el.title')
      .table__cell.table__cell_name(v-if="el.sections && el.sections.length !== 0")
        .dropdown-toggle(
          :id="`#nested-sectionIcon-${el.id ? el.id : el.indexEl}`", @click="toogleSections(el.id ? el.id : el.indexEl)"
          :class="[el.sections && el.sections.length !== 0 || el.children && el.children.length !== 0 ? 'active' : '']"
          )
          b-icon.mr-2(v-if="el.sections && el.sections.length !== 0 || el.children && el.children.length !== 0" icon="chevron-compact-down")
          b-icon.mr-2(v-else icon="chevron-compact-right")
          | {{ el.title }}
        nested-draggable(:policies='el.children ? el.children : el.sections')
      .table__cell.table__cell_name(v-else) {{ el.title }}
      .table__cell(v-if="el.status")
        .status.status__draft {{ el.status }}
      .table__cell(v-if="el.updated_at") {{ dateToHuman(el.updated_at) }}
      .table__cell(v-if="el.created_at") {{ dateToHuman(el.created_at) }}
      .table__cell(v-if="el.created_at") N/A
      .table__cell(v-if="el.created_at")
        .actions
          button.px-0.actions__btn(:id="`#nested-actionIcon-${el.id ? el.id : el.indexEl}`", @click="toogleActions(el.id ? el.id : el.indexEl)")
            b-icon(icon="three-dots")
          ul.actions-dropdown(:id="`#nested-action-${el.id ? el.id : el.indexEl}`")
            li.actions-dropdown__item.edit
              a.link(:href="'/business/compliance_policies/'+el.id") Edit
            li.actions-dropdown__item.move-up(@click="moveUp(el.id ? el.id : el.indexEl)") Move up
            li.actions-dropdown__item.delete
              PoliciesModalDelete(@saved="updateList", :policyId="el.id ? el.id : el.indexEl", @deleteConfirmed="deletePolicy(el.id ? el.id : el.indexEl)") Delete
</template>
<script>
  import draggable from "vuedraggable";
  import { DateTime } from 'luxon'
  import PoliciesModalDelete from "../PoliciesModalDelete";
  export default {
    props: ['policies'],
    name: "nested-draggable",
    components: {
      draggable,
      PoliciesModalDelete
    },
    methods: {
      updateList () {
        this.$store
          .dispatch("getPolicies")
          .then((response) => {
            // console.log(response);
          })
          .catch((err) => {
            console.error(err);
            this.makeToast('Error', err.message)
          });
      },
      checkMove: function(evt){
        console.log('checkMove')
        console.log(evt.relatedContext)
        console.log(evt)
        console.log(evt.draggedContext)
        console.log(evt.draggedContext.element)
        return (evt.draggedContext.element.name!=='apple');
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
        // console.log(policyId)
        const index = this.policies.findIndex(record => record.id === policyId);
        // policies[index] = payload;
        const curPos = this.policies[index].position
        const newPos = this.policies[index - 1].position

        this.policies[index - 1].position = curPos
        this.policies[index].position = newPos

        const arrToChange = [
          {
            id: this.policies[index - 1].id,
            position: this.policies[index - 1].position
          },
          {
            id: this.policies[index].id,
            position: this.policies[index].position
          }
        ]

        this.$store
          .dispatch("moveUpPolicy", arrToChange)
          .then((response) => {
            // console.log('response', response)
            this.makeToast('Success', 'Policy succesfully moved.')
          })
          .catch((err) => {
            // console.error(err)
            this.makeToast('Error', err.message)
          });
      },
      deletePolicy(policyId) {
        this.$store
          .dispatch('deletePolicyById', { policyId })
          .then(response => {
            this.makeToast('Success', `Policy successfully deleted!`)
          })
          .catch(error => {
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
    },
  };
</script>
<style scoped>
  .dragArea {
    min-height: 50px;
    outline: 1px dashed;
    transition: all 200ms ease-in;
  }
  .dragArea:hover,
  .dragArea:active {
    /*height: 50px;*/
    outline-color: #ced4da;
  }
</style>
