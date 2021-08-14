<template lang="pug">
  .page(@mouseover="mouseOver")
    .page-header
      h2.page-header__title {{ pageTitle }}
      .page-header__actions
        button.btn.btn-default(@click="zipping" :disabled="disabled")
          b-icon.m-r-1(v-if="disabled" icon="arrow-counterclockwise" animation="spin-reverse-pulse" font-scale="1")
          b-icon.m-r-1(v-else icon="file-zip" font-scale="1")
          | Download ZIP
    .card-body.white-card-body.card-body_full-height.p-x-40
      .d-flex.align-items-center.mb-2
        a.btn.btn-default.m-r-1.p-0(v-if="currentFolderId" @click.stop="backToRoot")
          b-icon(icon="arrow-left-square" font-scale="1")
        h4.m-b-0 All Documents
          span.separator(v-if="currentFolderName") &nbsp/&nbsp;
          span(v-if="currentFolderName") {{ currentFolderName }}
      .d-flex
        input(ref="inputFile" type="file" hidden @change="uploadFile")
        b-button.m-r-1(variant="dark" @click="selectFile") Upload
        FoldersModalCreate
          b-button(variant="light") New Folder
      .d-block
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
        zipStatus: false,
        zipCounter: 0,
        pageFolderName: '',
        refreshTimer: 0,
      };
    },
    created() {

    },
    methods: {
      ...mapActions({
        startZipping: 'filefolders/startZipping',
        getFileFoldersById: 'filefolders/getFileFoldersById',
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
            // file_folder_id: this.currentFolderId,
            file: this.file,
            name: this.file.name
          }
        }

        if (this.currentFolderId) params.file_doc.file_folder_id = this.currentFolderId

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
            this.zipStatus = false
            this.disabled = false
          })
      },
      async zipping() {
        if (!this.currentFolderId) return

        try {
          // console.log('zipping')
          this.disabled = true
          await this.$store.dispatch('filefolders/startZipping')
            .then(response => {
              // console.log(response)
              this.makeToast('Success', `${response.message}`)

              setTimeout(() => {
                this.zippinTimerChecker()
                this.zipCounter++
              }, 5000)
            })
            .catch(error => {
              console.error(response)
              this.zipStatus = false
              this.disabled = false
            })
            // .finally(() => this.zippinTimerChecker()) // FOR TESTS
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
      async zippinTimerChecker(){
        try {
          // console.log('zipping')
          this.disabled = true
          await this.$store.dispatch('filefolders/checkZipping')
            .then(response => {
              // console.log(response)
              // this.zipCounter = 11
              if (!response.complete) {
                setTimeout(() => {
                  this.zippinTimerChecker()
                  this.zipCounter++
                }, 5000)
              }

              if (response.complete) {
                this.zipStatus = true
                this.makeToast('Success', 'Zipping completed! Dowloading started.')

                // const url = response.path
                // this.forceFileDownload(response.path)
                this.download(response.path, `Books and Records ${this.currentFolderId}.zip`);
                this.disabled = false
              }
            })
            .catch(error => console.error(response))
            // .finally(() => {
            //   // If automatic requests less or equal 10
            //   if (this.zipCounter <= 10) {
            //     if(!this.zipStatus) {
            //       setTimeout(() => {
            //         this.zippinTimerChecker()
            //         this.zipCounter++
            //       }, 5000)
            //     }
            //   } else {
            //     this.disabled = false
            //     this.makeToast('Error', 'Requests for checking is too much!')
            //   }
            // })
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
      // forceFileDownload(response){
      //   const url = window.URL.createObjectURL(new Blob([response]))
      //   const link = document.createElement('a')
      //   link.href = url
      //   link.setAttribute('download', 'file.zip') //or any other extension
      //   document.body.appendChild(link)
      //   link.click()
      // },
      download(dataurl, filename) {
        var a = document.createElement("a");
        a.href = dataurl;
        a.setAttribute("download", filename);
        a.click();
      },
      async backToRoot (e) {
        try {
          await this.$store.dispatch('filefolders/getFileFolders')
            .then(() => {
              this.$store.commit('filefolders/SET_CUREENT_FOLDER', null)
              this.$store.commit('filefolders/SET_CUREENT_FOLDER_NAME', null)
            })
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
      mouseOver: function(event){
        if (event) this.refreshTimer++
        if (this.refreshTimer === 300) {
          this.refreshFolders()
          this.refreshTimer = 0;
        }
      },
      async refreshFolders() {
        await this.$store.dispatch('filefolders/getFileFolders')
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
      // pageFolderName() {
      //   if (!this.currentFolderId) return ''
      //   return this.filefolders.folders.find(folder => {
      //     if (folder.id === this.currentFolderId) return folder.name
      //   })
      // }
    },
    async mounted () {
      try {
        const currentPage = window.location.pathname.match( /\d+/g )
        if(!currentPage) await this.$store.dispatch('filefolders/getFileFolders') // default fiflefolders

        // if id exist in URL get fiflefolders
        if(currentPage) {
          await this.getFileFoldersById(currentPage[0])
          this.$store.commit('filefolders/SET_CUREENT_FOLDER', currentPage[0])
        }
      } catch (error) {
        console.error(error)
        this.makeToast('Error', error.message)
      }
    },
  };
</script>

<style>
  @import "./styles.css";
</style>
