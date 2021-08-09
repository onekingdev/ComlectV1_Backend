<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" size="xl" title="Select Files(s)" @show="newEtag" @shown="getData")
      .card
        .card-header.px-0
          b-tabs(content-class="mt-0 px-0")
            b-tab(title="Book and Records" title-item-class="font-weight-bold" active)
              .card-body
                .row.m-b-1
                  .col-12.p-x-1
                    .d-flex.align-items-center
                      a.btn.btn-default.m-r-1.p-0(v-if="currentFolderId" @click.stop="backToRoot")
                        b-icon(icon="arrow-left-square" font-scale="1")
                      h4.m-b-0 All Documents
                        span.separator(v-if="currentFolderName") &nbsp/&nbsp;
                        span(v-if="currentFolderName") {{ currentFolderName }}
                .row.m-b-1
                  .col-12.p-x-1
                    Loading
                    FilefoldersTable(v-if="!loading && filefolders.files && filefolders.folders" :filefolders="filefolders" :check="true" @selectedItem="collecingFiles")
                    .row.h-100(v-if="!filefolders.files && !filefolders.folders && !loading")
                      .col.h-100.text-center
                        EmptyState
            b-tab(title="Policies" title-item-class="font-weight-bold")
              div
                table.table
                  thead
                  tbody
                    tr
                      td.text-center(colspan=5)
                        h4.py-2 No Policies

      template(slot="modal-footer")
        .col
          label.m-t-1.form-label.font-weight-bold {{ countSelected }} Items Selected
        .col-justify-content-end
          a.btn.link.btn-link(@click="$bvModal.hide(modalId)") Cancel
          button.btn.btn-dark(@click="submit") Add
</template>

<script>
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import { mapActions, mapGetters } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import FilefoldersTable from '@/business/filefolders/components/FilefoldersTable'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  async function createFile(path, name){
    let response = await fetch(path);
    let data = await response.blob();
    let metadata = {
      type: 'image/jpeg'
    };
    let file = new File([data], name, metadata);

    return file;
  }

  export default {
    mixins: [EtaggerMixin()],
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      currentExamId: {
        type: Number,
        required: true
      },
      request: {
        type: Object,
        required: true
      },
    },
    components: {
      Loading,
      FilefoldersTable,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        filesCollection: []
      }
    },
    methods: {
      ...mapActions({
        getFileFoldersById: 'filefolders/getFileFoldersById',
      }),
      async submit(e) {
        e.preventDefault();
        try {
          let formData = new FormData()
          for (const fileFromCollection of this.filesCollection) {

            createFile(`${window.location.origin}/${fileFromCollection.file_addr}`, fileFromCollection.name)
              .then(file => {
                formData.append('file', file);
                const data = {
                  id: this.currentExamId,
                  request: { id: this.request.id },
                  formData
                }

                const sendFIle = new Promise((resolve, reject) => {
                  this.$store.dispatch('exams/uploadExamRequestFile', data)
                    .then(response => resolve(response))
                    .catch(error => reject(error))
                });

                sendFIle
                  .then(response => this.toast('Success', `${response.name} successful uploaded!`))
                  .catch(error => this.toast('Error', error.message))
              })
              .catch(error => console.error(error))
          }

        } catch (error) {
          this.toast('Error', error.message)
        } finally {
          this.filesCollection = []
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
        }
      },
      async backToRoot (e) {
        try {
          await this.$store.dispatch('filefolders/getFileFolders')
            .then(() => {
              this.$store.commit('filefolders/SET_CUREENT_FOLDER', null)
              this.$store.commit('filefolders/SET_CUREENT_FOLDER_NAME', null)
            })
        } catch (error) {
          this.toast('Error', error.message)
        }
      },
      async getData () {
        try {
          await this.$store.dispatch('filefolders/getFileFolders')

          // const currentPage = window.location.pathname.match( /\d+/g )
          // if(!currentPage) await this.$store.dispatch('filefolders/getFileFolders') // default fiflefolders
          //
          // // if id exist in URL get fiflefolders
          // if(currentPage) {
          //   await this.getFileFoldersById(currentPage[0])
          //   this.$store.commit('filefolders/SET_CUREENT_FOLDER', currentPage[0])
          // }
        } catch (error) {
          console.error(error)
          this.toast('Error', error.message)
        }
      },
      collecingFiles (form) {
        if (form.status) {
          if(!this.filesCollection.includes(form.file)) this.filesCollection.push(form.file)
        }
        if (!form.status) {
          const index = this.filesCollection.findIndex(record => record.id === form.file.id);
          this.filesCollection.splice(index, 1)
        }
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      ...mapGetters({
        filefolders: 'filefolders/filefolders',
        currentFileFolders: 'filefolders/currentFileFolders',
        currentFolderId: 'filefolders/currentFolder',
        currentFolderName: 'filefolders/currentFolderName'
      }),
      countSelected() {
        return this.filesCollection.length
      }
    },
  }
</script>

