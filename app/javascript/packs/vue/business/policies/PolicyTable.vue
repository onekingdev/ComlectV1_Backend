<template lang="pug">
  div
    .row.my-3
      .col-4
        .position-relative
          b-icon.icon-searh(icon='search')
          input.form-control(type="text" placeholder="Search" v-model="searchInput", @keyup="searching")
      .col-4(v-if="policies.length !== 0 && searchInput") Found {{ policies.length }} results
    .row
      .col-12
        .table(v-if="policies.length !== 0")
          .table__row
            .table__cell.table__cell_title Name
            .table__cell.table__cell_title.table__cell_clickable
              | Status
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable
              | Last Modified
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable
              | Date Created
              b-icon.ml-2(icon='chevron-expand')
            .table__cell.table__cell_title.table__cell_clickable
              | Risk Level
              b-icon.ml-2(icon='chevron-expand')
            .table__cell
          .table__row(v-for="policy in policies" :key="policy.id")
            .table__cell.table__cell_name(v-if="policy.sections.length !== 0")
              .dropdown-toggle(:id="'#sectionIcon-'+policy.id", @click="toogleSections(policy.id)")
                b-icon.mr-2(icon='chevron-compact-right')
                | {{ policy.name }}
              ul.dropdown-items(:id="'#section-'+policy.id")
                .li.dropdown-item(v-for="(section, sectionIndex) in policy.sections" :key="sectionIndex") {{ section.title }}
            .table__cell.table__cell_name(v-else) {{ policy.name }}
            .table__cell
              .status.status__draft {{ policy.status }}
            .table__cell {{ dateToHuman(policy.updated_at) }}
            .table__cell {{ dateToHuman(policy.created_at) }}
            .table__cell N/A
            .table__cell
              .actions
                button.px-0.actions__btn(:id="'#actionIcon-'+policy.id", @click="toogleActions(policy.id)")
                  b-icon(icon="three-dots")
                ul.actions-dropdown(:id="'#action-'+policy.id")
                  li.actions-dropdown__item.edit
                    a.link(:href="'/business/compliance_policies/'+policy.id") Edit
                  li.actions-dropdown__item.move-up(@click="moveUp(policy.id)") Move up
                  li.actions-dropdown__item.delete
                    PoliciesModalDelete(@saved="updateList", :policyId="policy.id") Delete
        .table(v-else)
          .table__row
            .table__cell.text-center
              h3 Policies not exist
</template>

<script>
  import PoliciesModalDelete from './PoliciesModalDelete'
  import { DateTime } from 'luxon'

  export default {
    props: ['policies'],
    components: {
      PoliciesModalDelete
    },
    data() {
      return {
        searchInput: '',
        isActive: false,
      }
    },
    methods: {
      dateToHuman (value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('dd/MM/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      searching () {
        this.$emit('searching', this.searchInput)
      },
      toogleActions(value) {
        document.getElementById(`#action-${value}`).classList.toggle('active');
        document.getElementById(`#actionIcon-${value}`).classList.toggle('active');
      },
      toogleSections(value) {
        document.getElementById(`#section-${value}`).classList.toggle('active');
        document.getElementById(`#sectionIcon-${value}`).classList.toggle('active');
      },
      moveUp(policyId) {
        console.log(policyId)
        const index = this.policies.findIndex(record => record.id === policyId);
        // policies[index] = payload;
        const curPos = this.policies[index].position
        const newPos = this.policies[index - 1].position

        this.policies[index - 1].position = curPos
        this.policies[index].position = newPos

        const arrToChange = [
          {
            policyId: this.policies[index - 1].id,
            position: this.policies[index - 1].position
          },
          {
            policyId: this.policies[index].id,
            position: this.policies[index].position
          }
        ]

        this.$store
          .dispatch("moveUpPolicy", arrToChange)
          .then((response) => {
            console.log('response', response)
            this.makeToast('Success', 'Policy succesfully moved.')
          })
          .catch((err) => {
            console.log(err)
            this.makeToast('Error', err.message)
          });
      },
      deletePolicy(policyId) {
        console.log(policyId)
      },
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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
    },
    computed: {

    }
  }
</script>
