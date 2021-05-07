<template lang="pug">
  div
    .container
      .row
        .col-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            h2 {{ pageTitle }}
          div
            a.btn.btn-default(href='#') Download ZIP
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
  import { mapGetters } from "vuex"
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
      };
    },
    created() {

    },
    methods: {
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
