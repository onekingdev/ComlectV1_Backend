<template lang="pug">
  <!--draggable.dragArea(tag='tbody' :list='policies' :group="{ name: 'g1' }" :move="checkMove" @end="onEnd")-->
  draggable.dragArea(v-bind="dragOptions" tag="tbody" :list="list" :value="value" :move="checkMove" @end="onEnd" @input="emitter")
    .table__row(v-for='el in realValue' :key='el.title' :data-id-policy="el.id")
      .table__cell.table__cell_name(v-if="el.children && el.children.length !== 0")
        .dropdown-toggle(
          :id="`#nested-sectionIcon-${el.id}`", @click="toogleSections(el.id)"
          :class="[el.children && el.children.length !== 0 ? 'active' : '']"
          )
          b-icon.mr-2(v-if="el.children && el.children.length !== 0" icon="chevron-compact-down")
          b-icon.mr-2(v-else icon="chevron-compact-right")
          | {{ el.title }}
        nested-draggable(
        :list="el.children"
        :policy="el"
        :policyId="el.id ? el.id : parentSection.id"
        :policyTitle="el.title"
        :policiesList="policiesList"
        :parentSection="el"
        )
      .table__cell.table__cell_name(v-else) {{ el.title }}
      .table__cell(v-if="!shortTable && el.status")
        .status.status__draft {{ el.status }}
      .table__cell(v-if="!shortTable && el.updated_at") {{ dateToHuman(el.updated_at) }}
      .table__cell(v-if="!shortTable && el.created_at") {{ dateToHuman(el.created_at) }}
      .table__cell(v-if="!shortTable && el.created_at") N/A
      .table__cell(v-if="!shortTable && el.created_at")
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
        // console.log('relatedContext', evt.relatedContext)
        // console.log('draggedContext:', evt.draggedContext)

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
        if(this.policyTitle && this.policy.id) {
          this.sections = evt.relatedContext.list
        }

        // 4. MOVE Section of POLICY INSIDE another POLICY
        // 5. MOVE Section Child of POLICY INSIDE this POLICY
        if(!evt.draggedContext.element.id) {
          this.draggedContext = evt.draggedContext
          this.relatedContext = evt.relatedContext
          this.children = evt.relatedContext.list
        }
        // 6. MOVE Section Child of POLICY INSIDE another POLICY
        // 7. MOVE UP Section POLICY INSIDE this POLICY
        // 8. MOVE DOWN Section POLICY INSIDE this POLICY
        // 9. MOVE UP Section Child POLICY INSIDE this POLICY
        // 10. MOVE DOWN Section Child POLICY INSIDE this POLICY
      },
      onEnd(evt){
        // console.log('event', evt)
        // let idPolicy = null
        //
        console.log('relatedContext', this.relatedContext)
        console.log('draggedContext:', this.draggedContext)
        console.log('policiesList:', this.policiesList)
        console.log('realValue:', this.realValue)
        console.log('this.policy:', this.policy)
        console.log('this.policyId:', this.policyId)
        console.log('this.policyTitle:', this.policyTitle)
        console.log('this.parentSection:', this.parentSection)
        console.log('this.parentSection:', this.parentSection?.parentSection)

        if (!this.policyTitle) {
          this.movePolicy()
          return
        }
        //
        // if(this.policyTitle && this.sections) {
        //   const policy = this.policiesList.find(policy => policy['title'] === this.policyTitle)
        //
        //   this.$store.dispatch("updatePolicy", {
        //     id: policy.id,
        //     sections: this.sections
        //   });
        // }

        const targetTitle = this.relatedContext.element.title;
        console.log('targetTitle', targetTitle)
        let targetPolicy = null
        let targetPolicyDetele = null

        // HADCODED - NEED REWRITE
        this.policiesList.forEach(function(policy, index) {
          if(policy.title === targetTitle) targetPolicy = policy
          policy.children.forEach(function(children, index) {
            if(children.title === targetTitle) targetPolicy = policy
            children.children.forEach(function(children, index) {
              if(children.title === targetTitle) targetPolicy = policy
              children.children.forEach(function(children, index) {
                if(children.title === targetTitle) targetPolicy = policy
                children.children.forEach(function(children, index) {
                  if(children.title === targetTitle) targetPolicy = policy
                })
              })
            })
          })
        })

        // const searchTargetPolicy = function(array, searchTitle, policy) {
        //   array.children.forEach(function(el, index) {
        //     if(el.title === searchTitle) targetPolicy = policy
        //     if(el.children) el.children.forEach(function(children, index) {
        //       if(children.title === targetTitle) targetPolicy = policy
        //     })
        //   })
        // }
        //
        // this.policiesList.forEach(function(policy, index, arr) {
        //   if(policy.title === targetTitle) targetPolicy = policy
        //   searchTargetPolicy(policy, targetTitle, arr);
        // })

        if(targetPolicy) {
          this.policiesList.forEach(function(policy, index) {
            if(targetPolicy.id !== policy.id) {
              if(policy.title === targetTitle)
              {
                targetPolicyDetele = policy
                policy.splice(index, 1)
              }
              policy.children.forEach(function(children, index) {
                if(children.title === targetTitle)
                {
                  targetPolicyDetele = policy
                  policy.children.splice(index, 1)
                }
                children.children.forEach(function(children, index) {
                  if(children.title === targetTitle)
                  {
                    targetPolicyDetele = policy
                    children.children.splice(index, 1)
                  }
                  children.children.forEach(function(children, index) {
                    if(children.title === targetTitle)
                    {
                      targetPolicyDetele = policy
                      children.children.splice(index, 1)
                    }
                  })
                })
              })
            }
          })
        }

        console.log('targetPolicy', targetPolicy)
        console.log('targetPolicyDetele', targetPolicyDetele)

        if(targetPolicy) {
          this.$store.dispatch("updatePolicy", {
            id: targetPolicy.id,
            sections: targetPolicy.children
          })
            .then((response) => {
              console.log('response in nested updating a tree', response)
              this.makeToast('Success', 'Changes succesfully saved.')
            })
        }
        if(targetPolicyDetele) {
          this.$store.dispatch("updatePolicy", {
            id: targetPolicyDetele.id,
            sections: targetPolicyDetele.children
          })
            .then((response) => {
              console.log('response in nested updating a tree', response)
              this.makeToast('Success', 'Changes succesfully saved.')
            })
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
        console.log(value)
        console.log(document.getElementById(`#nested-section-${value}`))
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
      emitter(value) {
        console.log('emit value', value)
        this.$emit("input", value);
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
      // this.value when input = v-model
      // this.list  when input != v-model
      realValue() {
        return this.value ? this.value : this.list;
      },
    },
    watch: {
      policiesList (value) {
        console.log('watch policies', value)
      },
    },
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
