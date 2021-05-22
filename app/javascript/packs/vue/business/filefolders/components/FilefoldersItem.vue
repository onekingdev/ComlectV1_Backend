<template lang="pug">
  tr
    td.align-middle
      .d-flex.align-items-center
        a.link.d-flex.align-items-center(:href="itemType === 'file' ? item.file_addr : '#'" :target="itemType === 'file' ? '_blank' : '_self'" @click="openFolder($event, item.id, item.file_addr, item.name)")
          ion-icon.m-r-1(:name="itemType === 'folder' ? 'folder-outline' : 'document-outline'" size="small")
          | {{ item.name }}
        span.m-l-1(v-if="disabled")
          b-icon.m-r-1(icon="arrow-counterclockwise" animation="spin-reverse-pulse" font-scale="1")
          | Zipping...
    td.align-middle.text-right {{ item.owner }}
    td.align-middle.text-right
      div(v-if="itemType === 'folder'") -
      div(v-else) {{ item.size ? item.size : 0}}
    td.align-middle.text-right {{ dateToHuman(item.updated_at) }}
    td.text-right
      .actions
        b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
          template(#button-content)
            b-icon(icon="three-dots")
          b-dropdown-item(v-if="item.locked" :disabled="item.locked" v-b-tooltip.hover.left="'Cant be edited!'") Edit
          FoldersModalEdit(v-else, :item="item", :inline="false")
            b-dropdown-item Edit
          b-dropdown-item(@click="zipping(item.id, item.name)" :disabled="disabled")
            b-icon.m-r-1(v-if="disabled" icon="arrow-counterclockwise" animation="spin-reverse-pulse" font-scale="1")
            | Download
          b-dropdown-item(v-if="item.locked" :disabled="item.locked" v-b-tooltip.hover.left="'Cant be moved!'") Move to
          FoldersModalMoveTo(v-else @movedConfirmed="moveToFileFolder", :item="item", :inline="false")
            b-dropdown-item Move to
          b-dropdown-item-button.delete(v-if="item.locked" :disabled="item.locked" variant='danger' v-b-tooltip.hover.left="'Cant be deleted!'" )
            <!--b-icon.mr-1(icon='x-circle' aria-hidden='true')-->
            | Delete
          FilefoldersModalDelete(v-else @deleteConfirmed="deleteFileFolderItem(item.id, itemType)" :inline="false")
            b-dropdown-item(:disabled="item.locked").delete Delete

</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex"
import { DateTime } from 'luxon'
import FoldersModalMoveTo from '../modals/FoldersModalMoveTo'
import FoldersModalEdit from '../modals/FoldersModalEdit'
import FilefoldersModalDelete from '../modals/FilefoldersModalDelete'

export default {
  name: "ReviewItem",
  props: ['item', 'itemType'],
  components: {
    FoldersModalMoveTo,
    FoldersModalEdit,
    FilefoldersModalDelete
  },
  data () {
    return {
      zipCounter: 0,
      disabled: false
    }
  },
  methods: {
    ...mapMutations({
      setCurrentReviewFolder: 'filefolders/SET_CUREENT_FOLDER'
    }),
    ...mapActions({
      getFileFolders: 'filefolders/getFileFolders',
      getCurrentReviewFileFoldersById: 'filefolders/getFileFoldersById',
      deleteFileFolder: 'filefolders/deleteFileFolder',
    }),
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('dd/MM/yyyy')
      }
      if (date.invalid) {
        return value
      }
    },
    openFolder(e, folderId, fileAddr, folderName) {
      if (fileAddr) return

      e.preventDefault()
      console.log('folderId', folderId)
      if (folderName) this.$store.commit('filefolders/SET_CUREENT_FOLDER_NAME', folderName)

      // const url = new URL(window.location);
      // window.history.pushState({}, '', `${url}/${folderId}`);

      this.getCurrentReviewFileFoldersById(folderId)
      this.setCurrentReviewFolder(folderId)
    },
    downloadFileFolder(filefolderId){
      // this.$store.dispatch('annual/duplicateReview', { id: filefolderId })
      //   .then(response => this.toast('Success', ` ${response.message}`))
      //   .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    async zipping(itemId, itemName) {
      if (!itemId) return

      try {
        // console.log('zipping')
        this.disabled = true
        await this.$store.dispatch('filefolders/startZipping', { id: itemId })
          .then(response => {
            // console.log(response)
            this.makeToast('Success', `${response.message}`)

            setTimeout(() => {
              this.zippinTimerChecker(itemId, itemName)
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
    async zippinTimerChecker(itemId, itemName){
      try {
        this.disabled = true
        await this.$store.dispatch('filefolders/checkZipping', { id: itemId })
          .then(response => {
            if (!response.complete) {
              setTimeout(() => {
                this.zippinTimerChecker(itemId, itemName)
                this.zipCounter++
              }, 5000)
            }

            if (response.complete) {
              this.zipStatus = true
              this.makeToast('Success', 'Zipping completed! Dowloading started.')

              this.download(response.path, `${itemName} ${itemId}.zip`);
              this.disabled = false
            }
          })
          .catch(error => {
            console.error(error)
            this.zipStatus = false
            this.disabled = false
          })
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    download(dataurl, filename) {
      var a = document.createElement("a");
      a.href = dataurl;
      a.setAttribute("download", filename);
      a.click();
    },
    moveToFileFolder(e) {
      console.log('move done')
    },
    // deleteFileFolder(filefolderId, itemType){
    //   this.$store.dispatch('filefolders/deleteFileFolder', { id: filefolderId, itemType })
    //     .then(response => this.toast('Success', `${response.message}`))
    //     .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    // },
    async deleteFileFolderItem(id, itemType) {
      try {
        this.deleteFileFolder({id, itemType})
          .then(response => this.toast('Success', `${response.message}`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
  }
}
</script>

<style scoped>
  ion-icon {
    color: #565759;
  }
</style>
