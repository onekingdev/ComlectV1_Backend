<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Share Exam" hide-footer)
      .row(v-if="!show")
        .col.text-center
          p Exam is not completed yet. Are you sure want to share link?
          .d-flex.justify-content-center
            button.btn.mr-2(@click="$bvModal.hide(modalId)") No
            button.btn.btn-dark(@click="approveHandle") Yes
      .row(v-if="show")
        .col-12.m-b-1
          label.form-label Email
          .input-group
            input.form-control(v-model="exam.email" type="email" ref="input" @keyup="onChange")
            .input-group-append
              button.btn.btn-dark(@click="invite") Send
          Errors(:errors="errors.email")
      .row
        .col
          table.table(v-if="examAuditors && examAuditors.length")
            thead
              tr
                th(width="70")
                  .d-inline Invited
                th.text-right
            tbody
              tr(v-for="auditor in examAuditors" :key="auditor.id")
                td.auditor-email {{ auditor.email }}
                td.text-right
                  b-icon.remove-btn(icon="x" @click="unIinvite(auditor.id, auditor.email)")

      template(slot="modal-footer" footer-class="d-none")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        // button.btn.btn-dark(@click="invite") Send
</template>

<script>
  import Errors from '@/common/Errors'
  import UserAvatar from '@/common/UserAvatar'
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const EMAIL_FORMAT = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

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
      },
      examStatus: {
        type: Boolean,
        default: false
      },
    },
    components: {
      Errors,
      UserAvatar,
    },
    created() {
      if(this.examStatus) {
        this.show = true
      }
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
        },
        show: false
      }
    },
    methods: {
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
        this.errors = {}
        if (!this.exam.email) {
          this.errors = { email: ["Required field"] }
          return
        }

        if(!EMAIL_FORMAT.test(this.exam.email)) {
          this.errors = { email: ["Invalid email address"] }
          return
        }

        const data = {
          id: this.examId,
          email: this.exam.email
        }

        try {
          await this.$store.dispatch('exams/sendInvite', data)
            .then(response => {
              if(response.errors && Object.keys(response.errors)) {
                for (const [key, value] of Object.entries(response.errors)) {
                  this.$set(this.errors, key, value)
                }
              }

              if(!response.errors) {
                this.toast('Success', `Invitation has been sent.`)
                this.exam.email = ''
              }
            })
            .catch(error => console.error(error))

        } catch (error) {
          this.toast('Error', error.message, true)
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
              if(response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  this.toast('Error', `${key}: ${value}`, true)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
              }

              if(!response.errors) {
                this.toast('Success', `Invitation has been revoked.`)
              }
            })
            .catch(error => console.error(error))

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
      copyTestingCode () {
        let shareLinkToCopy = document.querySelector('#share-link')
        // shareLinkToCopy.setAttribute('type', 'text')
        shareLinkToCopy.select()

        try {
          var successful = document.execCommand('copy');
          var msg = successful ? 'successful' : 'unsuccessful';
          this.toast('Success', `Sharing link was copied ${msg}`)
        } catch (err) {
          this.toast('Error', `Oops, unable to copy`, true)
        }

        /* unselect the range */
        // shareLinkToCopy.setAttribute('type', 'hidden')
        window.getSelection().removeAllRanges()
      },
      approveHandle () {
        this.show = true
      }
    },
  }
</script>

<style scoped>
  .remove-btn {
    font-size: 20px;
    cursor: pointer;
  }

  .form-label__hidden {
    opacity: 0;
  }

  .auditor-email {
    width: 80% !important;
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

  tbody::-webkit-scrollbar {
    width: 10px;
    height: 15px; }

  tbody::-webkit-scrollbar-thumb {
    border-radius: 5px;
    background-image: -webkit-gradient(linear, left bottom, left top, from(#a8a8a8), to(#a8a8a8));
    background-image: linear-gradient(to top, #1B1C29, #2E304F); 
  }

  tbody::-webkit-scrollbar-track {
    background: rgba(0, 0, 0, 0.1);
    border-radius: 5px;
  }
</style>
