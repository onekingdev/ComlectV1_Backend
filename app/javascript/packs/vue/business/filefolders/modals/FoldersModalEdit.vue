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
        button.btn(@click="$bvModal.hide(modalId)") Cancel
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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();
        console.log(this.item)

        if (!this.file_folder.name) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }
        if (this.file_folder.name.length <= 3) {
          this.errors.push('Name is very short, must be more 3 characters.');
          this.makeToast('Error', 'Name is very short, must be more 3 characters.')
          return;
        }

        const data = {
          file_folder: {
            // ...this.item,
            name: this.file_folder.name,
          },
        }

        try {
          const response = await this.$store.dispatch('filefolders/updateFolder', { id: this.item.id, data })
          if (response.errors) {
            this.makeToast('Error', `${response.status}`)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            return
          }
          this.makeToast('Success', `Folder successfully created!`)
          this.$emit('editConfirmed')
          this.$bvModal.hide(this.modalId)

        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
  }
</script>
