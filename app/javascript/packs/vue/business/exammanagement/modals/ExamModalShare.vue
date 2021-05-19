<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Share Exam")
      .row
        .col-12.m-b-2
          label.form-label Email
          input.form-control(v-model="exam.email" type="email" placeholder="Enter the email" ref="input" @keyup="onChange")
      .row
        .col-9.pr-0
          input#share-link.form-control(:value="exam.link" type="text" disabled)
        .col-3.pl-0.text-center
          a.btn.link(@click.stop.prevent="copyTestingCode") Copy Link

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Send
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        exam: {
          email: '',
          link: 'http://192.168.56.3:3000/business/exam_management/21016060/443688408/preview?scrollOffset=700'
        },
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
          this.submit(e)
        }
      },
      async submit(e) {
        e.preventDefault();

        if (!this.exam.email || !this.exam.link) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        // try {
        //   await this.$store.dispatch('exams/createExam', this.exam)
        //   this.makeToast('Success', `Exam Management successfully created!`)
        //   this.$emit('saved')
        //   this.$bvModal.hide(this.modalId)
        //   this.resetForm()
        // } catch (error) {
        //   this.makeToast('Error', error.message)
        // }
      },
      copyTestingCode () {
        let testingCodeToCopy = document.querySelector('#share-link')
        testingCodeToCopy.setAttribute('type', 'text')
        testingCodeToCopy.select()

        try {
          var successful = document.execCommand('copy');
          var msg = successful ? 'successful' : 'unsuccessful';
          this.makeToast('Success', `Sharing link was copied ${msg}`)
        } catch (err) {
          this.makeToast('Error', `Oops, unable to copy`)
        }

        /* unselect the range */
        // testingCodeToCopy.setAttribute('type', 'hidden')
        window.getSelection().removeAllRanges()
      },
    },
    computed: {

    },
  }
</script>
