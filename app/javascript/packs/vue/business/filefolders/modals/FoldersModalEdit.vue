<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Folder Name")
      .row
        .col-12.m-b-2
          label.form-label Name
          input.form-control(v-model="fileFolder" type="text" placeholder="Enter the name of your folder" ref="input" v-on:keyup.enter="submit")
          Errors(:errors="errors.name")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import Errors from '@/common/Errors'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      item: {
        type: Object,
        required: true
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
      fileFolder: {
        get(){
          return this.item.name
        },
        set(value) {
          this.file_folder.name = value
        }
      }
    },
    methods: {
      async submit(e) {
        e.preventDefault();
        console.log()

        if (!this.file_folder.name) {
          this.toast('Error', `N - Required field`)
          return
        }
        if (this.file_folder.name.length <= 3) {
          this.errors.push('Name is very short, must be more 3 characters.');
          this.toast('Error', 'N - Name must be more than 3 characters.')
          return
        }

        // IF THIS ITEM IS FILE
        if (this.item.file_addr) {
          const params = {
            file_doc: {
              name: this.file_folder.name
            }
          }

          // if (this.currentFolderId) params.file_doc.file_folder_id = this.currentFolderId

          let formData = new FormData()
          Object.keys(params.file_doc)
            .map(specAttr => formData.append(`file_doc[${specAttr}]`, params.file_doc[specAttr]))
          this.$store
            .dispatch('filefolders/updateFile', { id: this.item.id, data: formData })
            .then(response => {
              if(!response.errors) {
                this.toast('Success', `File has been saved.`)
              }
            })
            .catch(error => {
              console.error(error)
              this.toast('Error', `File has not been saved.`)
            })

          return
        }

        // IF THIS ITEM IS A FOLDER
        const data = {
          file_folder: {
            // ...this.item,
            name: this.file_folder.name,
          },
        }

        try {
          const response = await this.$store.dispatch('filefolders/updateFolder', { id: this.item.id, data })
          if (response.errors) {
            this.toast('Error', `Folder has not been saved. Please Try again. ${response.status}`, true)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
            return
          }
          this.toast('Success', `Folder has been saved.`)
          this.$emit('editConfirmed')
          this.$bvModal.hide(this.modalId)

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
  }
</script>
