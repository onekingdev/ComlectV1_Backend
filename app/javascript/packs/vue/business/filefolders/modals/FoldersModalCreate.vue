<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Folder")
      .row
        .col-12.m-b-2
          label.form-label Name
          input.form-control(v-model="file_folder.name" type="text" placeholder="Enter the name of your folder" ref="input" v-on:keyup.enter="submit")
          Errors(:errors="errors.name")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
  import { mapGetters } from "vuex"
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
        errors: []
      }
    },
    computed: {
      ...mapGetters({
        parentId: 'filefolders/currentFolder'
      })
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();

        if (!this.file_folder.name) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }
        if (this.file_folder.name.length <= 3) {
          this.errors.push('Name is very short, must be more 3 characters.');
          this.makeToast('Error', 'Name is very short, must be more 3 characters.')
          return;
        }

        if(this.parentId) this.file_folder.parent_id = this.parentId

        try {
          const response = await this.$store.dispatch('filefolders/createFolder', this.file_folder)
          if (response.errors) {
            this.makeToast('Error', `${response.status}`)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            return
          }
          this.makeToast('Success', `Folder successfully created!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
          this.file_folder.name = ''
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
  }
</script>
