<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Move To")
      .row
        .col-12.m-b-2
          label.form-label Destination
          b-form-select(v-model="file_folder.destination" :errors="errors.destination" :options="destinationOptions")
          Errors(:errors="errors.name")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Confirm
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
      itemId: {
        type: Number,
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
          destination: null,
        },
        errors: []
      }
    },
    computed: {
      ...mapGetters({
        filefolders: 'filefolders/filefolders'
      }),
      destinationOptions() {
        return this.filefolders.folders.map(folder => {
          return { value: folder.id, text: folder.name }
        })
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();

        if (!this.file_folder.destination) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        const data = {
          "file_folder": {
            "parent_id": this.file_folder.destination
          }
        }

        try {
          const response = await this.$store.dispatch('filefolders/updateFolder', { id: this.itemId, data  })
          if (response.errors) {
            this.makeToast('Error', `${response.status}`)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            return
          }
          this.makeToast('Success', `Folder successfully created!`)
          this.$emit('moveToConfirmed')
          this.$bvModal.hide(this.modalId)
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
  }
</script>
