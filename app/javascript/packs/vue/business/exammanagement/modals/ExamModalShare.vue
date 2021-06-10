<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Share Exam" hide-footer)
      .row
        .col-10.m-b-2.pr-0
          label.form-label Email
          input.form-control(v-model="exam.email" type="email" placeholder="Enter the email" ref="input" @keyup="onChange")
          Errors(:errors="errors.email")
        .col.pl-0.text-right
          label.form-label__hidden Send
          button.btn.btn-dark(@click="invite") Send
      .row
        .col
          table.table.task_table(v-if="examAuditors && examAuditors.length")
            thead
              tr
                th(width="70")
                  .d-inline
                    | Name
                    b-icon.ml-2(icon='chevron-expand')
                th
                th.text-right
            tbody
              tr(v-for="auditor in examAuditors" :key="auditor.id")
                td(width="55")
                  UserAvatar(:user="specialist")
                td
                  p.mb-1: b name {{ auditor.name }}
                  p.mb-0 {{ auditor.email }}
                td.text-right
                  b-dropdown.actions.float-right(size="sm" variant="default" class="mt-1 p-0" right)
                    template(#button-content)
                      | Actions
                      b-icon.ml-1(icon="chevron-down")
                    b-dropdown-item.delete(@click="unIinvite(auditor.id, auditor.email)") Delete

      template(slot="modal-footer" footer-class="d-none")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        // button.btn.btn-dark(@click="invite") Send
</template>

<script>
  import Errors from '@/common/Errors'
  import UserAvatar from '@/common/UserAvatar'
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      examId: {
        type: Number,
        required: true
      },
      examAuditors: {
        type: Array,
        required: false,
      }
    },
    components: {
      Errors,
      UserAvatar,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        exam: {
          email: '',
          // link: 'http://192.168.56.3:3000/business/exam_management/21016060/443688408/preview?scrollOffset=700'
        },
        errors: {},
        specialist: {
          first_name: 'A',
          last_name: 'N'
        }
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      resetForm() {
        this.exam = {
          email: '',
          link: ''
        }
      },
      onChange(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.invite(e)
        }
      },
      async invite(e) {
        e.preventDefault();

        if (!this.exam.email) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        const data = {
          id: this.examId,
          email: this.exam.email
        }

        try {
          await this.$store.dispatch('exams/sendInvite', data)
            .then(response => {
              console.log(response)
              if(response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  this.toast('Error', `${key}: ${value}`)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
              }

              if(!response.errors) {
                this.makeToast('Success', `Invite successfully sended!`)
                // this.$emit('saved')
                // this.$bvModal.hide(this.modalId)
                // this.resetForm()
              }
            })
            .catch(error => console.error(error))

        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
      async unIinvite(id, email) {

        const data = {
          id: this.examId,
          auditorId: id,
          email: email
        }

        try {
          await this.$store.dispatch('exams/sendUninvite', data)
            .then(response => {
              console.log(response)
              if(response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  this.toast('Error', `${key}: ${value}`)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
              }

              if(!response.errors) {
                this.makeToast('Success', `Invite successfully removed!`)
                // this.$emit('saved')
                // this.$bvModal.hide(this.modalId)
                // this.resetForm()
              }
            })
            .catch(error => console.error(error))

        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
      copyTestingCode () {
        let shareLinkToCopy = document.querySelector('#share-link')
        // shareLinkToCopy.setAttribute('type', 'text')
        shareLinkToCopy.select()

        try {
          var successful = document.execCommand('copy');
          var msg = successful ? 'successful' : 'unsuccessful';
          this.makeToast('Success', `Sharing link was copied ${msg}`)
        } catch (err) {
          this.makeToast('Error', `Oops, unable to copy`)
        }

        /* unselect the range */
        // shareLinkToCopy.setAttribute('type', 'hidden')
        window.getSelection().removeAllRanges()
      },
    },
    computed: {

    },
  }
</script>

<style scoped>
  .form-label__hidden {
    opacity: 0;
  }

  table, tr td {
    /*border: 1px solid red*/
  }
  tbody {
    display: block;
    max-height: 20rem;
    overflow: auto;
  }
  thead, tbody tr {
    display: table;
    width: 100%;
    table-layout: fixed;/* even columns width , fix width of table too*/
  }
  thead {
    width: calc( 100% - 1em )/* scrollbar is average 1em/16px width, remove it from thead width */
  }
  table {
    /*width: 400px;*/
  }

  tbody::-webkit-scrollbar {
    width: 10px;
    height: 15px; }

  tbody::-webkit-scrollbar-thumb {
    border-radius: 5px;
    background-image: -webkit-gradient(linear, left bottom, left top, from(#a8a8a8), to(#a8a8a8));
    background-image: linear-gradient(to top, #1B1C29, #2E304F); }

  tbody::-webkit-scrollbar-track {
    background: rgba(0, 0, 0, 0.1);
    border-radius: 5px; }
</style>
