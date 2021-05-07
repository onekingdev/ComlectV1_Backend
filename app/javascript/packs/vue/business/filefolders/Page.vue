<template lang="pug">
  div
    .container
      .row
        .col-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            h2 {{ pageTitle }}
          div
            button.btn.btn-default(@click="zipping" :disabled="disabled")
              b-icon.m-r-1(v-if="disabled" icon="arrow-counterclockwise" animation="spin-reverse-pulse" font-scale="1")
              b-icon.m-r-1(v-else icon="file-zip" font-scale="1")
              | Download ZIP
    .container-fluid.p-x-0
      .row
        .col-12.px-0
          .card-body.white-card-body
            .container
              .row.m-b-1
                .col-12
                  h4.m-b-1 All Documents
                    <!--span.separator(v-if="pageFolderName") &nbsp/&nbsp;-->
                    <!--span(v-if="pageFolderName") {{ pageFolderName }}-->
                  input(ref="inputFile" type="file" hidden @change="uploadFile")
                  b-button.m-r-1(variant="dark" @click="selectFile") Upload
                  FoldersModalCreate
                    b-button(variant="light") New Folder
              .row
                .col-12
                  Loading
                  FilefoldersTable(v-if="!loading && filefolders.files && filefolders.folders" :filefolders="filefolders")
                  table.table.reviews-table(v-if="!filefolders.files && !filefolders.folders && !loading")
                    tbody
                      tr
                        td.text-center
                          h3 Documents not exist

</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import FoldersModalCreate from './modals/FoldersModalCreate'
  import FilefoldersTable from './components/FilefoldersTable'

  export default {
    components: {
      Loading,
      FoldersModalCreate,
      FilefoldersTable
    },
    data() {
      return {
        pageTitle: "Books and Records",
        file: null,
        inputFile: null,
        disabled: false,
        zipStatus: false
      };
    },
    created() {

    },
    methods: {
      ...mapActions({
        startZipping: 'filefolders/startZipping',
      }),
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      selectFile() {
        let fileInputElement = this.$refs.inputFile;
        fileInputElement.click();

        // Do something with chosen file
        this.file = this.$refs.inputFile.files[0];
      },
      uploadFile(){
        this.file = this.$refs.inputFile.files[0];

        const params = {
          file_doc: {
            // file_folder_id: this.parentFolderId,
            file: this.file,
            name: this.file.name
          }
        }

        if (this.parentFolderId) params.file_doc.file_folder_id = this.parentFolderId

        let formData = new FormData()
        Object.keys(params.file_doc)
          .map(specAttr => formData.append(`file_doc[${specAttr}]`, params.file_doc[specAttr]))

        // console.log('formData', formData)

        this.$store
          .dispatch('filefolders/uploadFile', formData)
          .then(response => {
            // console.log('response', response)

            if(!response.errors) {
              this.makeToast('Success', `File successfully sended!`)
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
          })
      },
      async zipping() {
        try {
          console.log('zipping')
          this.disabled = true
          await this.$store.dispatch('filefolders/startZipping')
            .then(response => console.log(response))
            .catch(error => console.error(response))
            .finally(() => this.zippinTimerChecker())
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
      async zippinTimerChecker(){
        try {
          console.log('zipping')
          this.disabled = true
          await this.$store.dispatch('filefolders/checkZipping')
            .then(response => {
              console.log(response)
              this.zipStatus = true
            })
            .catch(error => console.error(response))
            .finally(() => {
              if(!this.zipStatus) {
                setTimeout(() => {
                  this.zippinTimerChecker()
                }, 3000)
              }
            })
        } catch (error) {
          this.makeToast('Error', error.message)
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
        parentFolderId: 'filefolders/currentFolder'
      }),
      pageFolderName() {
        if (!this.parentFolderId) return ''
        return this.filefolders.folders.find(folder => {
          if (folder.id === this.parentFolderId) return folder.name
        })
      }
    },
    async mounted () {
      try {
        await this.$store.dispatch('filefolders/getFileFolders')
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

<style scoped>
  .separator {
    color: #ffc107;
  }
</style>
