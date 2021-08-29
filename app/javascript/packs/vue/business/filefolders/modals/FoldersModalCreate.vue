<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Folder")
      b-alert.m-b-20(v-if="error" variant="danger" show) {{ error }}

      .row
        .col-12
          label.form-label Name
          input.form-control(v-model="file_folder.name" type="text" placeholder="Enter the name of your folder" ref="input" v-on:keyup.enter="submit")
          Errors(:errors="errors.name")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import Errors from '@/common/Errors'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    components: {
      Errors,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        file_folder: {
          name: '',
        },
        errors: {},
        error: ''
      }
    },
    computed: {
      ...mapGetters({
        parentId: 'filefolders/currentFolder'
      })
    },
    methods: {
      ...mapActions({
        createFolder: 'filefolders/createFolder',
      }),
      async submit(e) {
        e.preventDefault();
        this.error = ''

        if (!this.file_folder.name) {
          this.error = 'Required field'
          return
        }
        if (this.file_folder.name.length <= 3) {
          // this.errors.push('Name is very short, must be more 3 characters.');
          this.error = 'Name must have more than 3 characters.'
          return;
        }

        if(this.parentId) this.file_folder.parent_id = this.parentId

        try {
          const response = await this.createFolder(this.file_folder)
          if (response.errors) {
            this.toast('Error', `Folder has not been created. Please try again. ${response.status}`, true)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
            return
          }
          if (!response.errors) {
            this.toast('Success', `Folder has been created.`)
            this.$emit('saved')
            this.$bvModal.hide(this.modalId)
            this.file_folder.name = ''
          }
        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
  }
</script>
