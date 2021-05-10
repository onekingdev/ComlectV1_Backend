<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Move To" @shown="getData")
      .row
        .col-12.m-b-2
          label.form-label Destination
          <!--ComboBox(v-model="file_folder.destination" :options="treeList" placeholder="Select target destination")-->
          b-form-select(v-model="file_folder.destination" :errors="errors.destination" :options="treeList")
          Errors(:errors="errors.name")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Confirm
</template>

<script>
  import { mapGetters } from "vuex"
  import Errors from '@/common/Errors'
  import ComboBox from '@/common/ComboBox'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: id })

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      item: {
        type: Object,
        required: true,
      },
    },
    components: {
      Errors,
      ComboBox
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        file_folder: {
          destination: null,
        },
        treeList: null,
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
      },
      linkToOptions() {

        return [
                {...toOption('Projects'), children: ['Some project', 'Another', 'One'].map(toOption)},
                {...toOption('Annual Reviews'), children: ['Annual Review 2018', 'Annual Review 1337', 'Some Review'].map(toOption)},
                {...toOption('Policies'), children: ['Pol', 'Icy', 'Policy 3'].map(toOption)}
               ]
      },
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

        // IF THIS ITEM IS FILE
        if (this.item.file_addr) {
          const params = {
            file_doc: {
              file_folder_id: this.file_folder.destination
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
                this.makeToast('Success', `File successfully updated!`)
              }
            })
            .catch(error => {
              console.error(error)
              this.makeToast('Error', `Something wrong! ${error}`)
            })

          return
        }

        // IF THIS ITEM IS A FOLDER
        const data = {
          "file_folder": {
            "parent_id": this.file_folder.destination
          }
        }

        try {
          const response = await this.$store.dispatch('filefolders/updateFolder', { id: this.item.id, data  })
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
      getData() {
        this.$store.dispatch('filefolders/getFileFoldersListTree', this.item.id)
          .then(response => {
            console.log(response)
            this.treeList = response.map(folder => {
              return { value: folder[1], text: folder[0] }
            })

            // let objectOption = {}
            // let objectOptionArr = []
            //
            // for(const [ name, id ] of this.treeList) {
            //   console.log(name, id)
            //
            //   if (name.match(/ - /)) {
            //     for (const prop of Object.getOwnPropertyNames(objectOption)) {
            //       delete objectOption[prop];
            //     }
            //     objectOptionArr = []
            //     objectOption = { ...{ id, label: name.slice(3) } , children: [] }
            //   }
            //   if (name.match(/ -- /)) {
            //     objectOptionArr.push({ id, label: name.slice(3)})
            //     objectOption = Object.assign(objectOption, {children: objectOptionArr} )
            //   }
            // }
            //
            // console.log('objectOption')
            // console.log(objectOption)
            //
            // return
            //
            //
            // const treeListOptions = this.treeList.map(node => {
            //   const [ name, id ] = node;
            //   console.log(name, id)
            //   console.log('reg:' + name + '-result:', name.match(/ - /))
            //   console.log('reg:' + name + '-result2:', name.match(/ -- /))
            //
            //   let objectOption = {}
            //   let objectOptionArr = []
            //
            //   if (name.match(/ - /)) {
            //     objectOption = { ...{ id, label: name.slice(3) } , children: [] }
            //   }
            //   if (name.match(/ -- /)) {
            //     objectOptionArr.push({ id, label: name.slice(3)})
            //     objectOption = Object.assign(objectOption, {children: objectOptionArr} )
            //   }
            //
            //   console.log('objectOption')
            //   console.log(objectOption)
            //   if (objectOption) return objectOption
            // })
            //
            // this.treeList = treeListOptions
          })
          .catch(error => {
            console.error(error)
            if (!this.treeList) this.treeList = this.destinationOptions
          })
      }
    },
  }
</script>
