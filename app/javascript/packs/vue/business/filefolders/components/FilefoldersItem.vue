<template lang="pug">
  tr
    td.align-middle
      a.link.d-flex.align-items-center(:href="itemType === 'file' ? item.file_addr : '#'" :target="itemType === 'file' ? '_blank' : '_self'" @click="openFolder($event, item.id, item.file_addr)")
        ion-icon.m-r-1(:name="itemType === 'folder' ? 'folder-outline' : 'document-outline'" size="small")
        | {{ item.name }}
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
          FoldersModalEdit(@editConfirmed="moveToFileFolder", :item="item", :inline="false")
            b-dropdown-item Edit
          b-dropdown-item(@click="downloadFileFolder(item.id)") Download
          FoldersModalMoveTo(@moveToConfirmed="moveToFileFolder", :itemId="item.id", :inline="false")
            b-dropdown-item Move to
          FilefoldersModalDelete(@deleteConfirmed="deleteFileFolder(item.id, itemType)" :inline="false")
            b-dropdown-item.delete Delete
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
  methods: {
    ...mapMutations({
      setCurrentReviewFolder: 'filefolders/SET_CUREENT_FOLDER'
    }),
    ...mapActions({
      getFileFolders: 'filefolders/getFileFolders',
      getCurrentReviewFileFoldersById: 'filefolders/getFileFoldersById',
      deleteFileFolder: 'filefolders/deleteFileFolder',
    }),
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('dd/MM/yyyy')
      }
      if (date.invalid) {
        return value
      }
    },
    openFolder(e, folderId, fileAddr) {
      if (fileAddr) return

      e.preventDefault()
      console.log('folderId', folderId)

      // const url = new URL(window.location);
      // window.history.pushState({}, '', `${url}/${folderId}`);

      this.getCurrentReviewFileFoldersById(folderId)
      this.setCurrentReviewFolder(folderId)
    },
    downloadFileFolder(filefolderId){
      this.$store.dispatch('annual/duplicateReview', { id: filefolderId })
        .then(response => this.toast('Success', ` ${response.message}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    async moveToFileFolder(){
      await this.getFileFolders
    },
    deleteFileFolder(filefolderId, itemType){
      this.$store.dispatch('filefolders/deleteFileFolder', { id: filefolderId, itemType })
        .then(response => this.toast('Success', `${response.message}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    }
  }
}
</script>

<style scoped>
  ion-icon {
    color: #565759;
  }
</style>
