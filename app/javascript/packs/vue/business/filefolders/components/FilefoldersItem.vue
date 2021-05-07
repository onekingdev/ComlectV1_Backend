<template lang="pug">
  tr
    td
      a.link.d-flex.align-items-center(:href='"/business/file_folders/" + item.id' @click="openFolder($event, item.id)")
        ion-icon.m-r-1(:name="itemType === 'folder' ? 'folder-outline' : 'document-outline'" size="small")
        | {{ item.name }}
    td.text-right owner
    td.text-right 0
    td.text-right {{ dateToHuman(item.updated_at) }}
    td.text-right
      .actions
        b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
          template(#button-content)
            b-icon(icon="three-dots")
          b-dropdown-item(@click="downloadFileFolder(item.id)") Download
          FoldersModalMoveTo(@moveToConfirmed="moveToFileFolder(item.id)", :itemId="item.id", :inline="false")
            b-dropdown-item Move to
          FilefoldersModalDelete(@deleteConfirmed="deleteFileFolder(item.id)", :inline="false")
            b-dropdown-item.delete Delete
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex"
import { DateTime } from 'luxon'
import FoldersModalMoveTo from '../modals/FoldersModalMoveTo'
import FilefoldersModalDelete from '../modals/FilefoldersModalDelete'

export default {
  name: "ReviewItem",
  props: ['item', 'itemType'],
  components: {
    FoldersModalMoveTo,
    FilefoldersModalDelete
  },
  methods: {
    ...mapMutations({
      setCurrentReviewFolder: 'filefolders/SET_CUREENT_FOLDER'
    }),
    ...mapActions({
      getCurrentReviewFileFoldersById: 'filefolders/getFileFoldersById',
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
    openFolder(e, folderId) {
      e.preventDefault()
      console.log('folderId', folderId)

      // const url = new URL(window.location);
      // window.history.pushState({}, '', `${url}/${folderId}`);

      this.getCurrentReviewFileFoldersById(folderId)
      this.setCurrentReviewFolder(folderId)
    },
    downloadFileFolder(filefolderId){
      this.$store.dispatch('annual/duplicateReview', { id: filefolderId })
        .then(response => this.toast('Success', `The annual review has been duplicated! ${response.id}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    moveToFileFolder(filefolderId){
      // this.$store.dispatch('annual/duplicateReview', { id: filefolderId })
      //   .then(response => this.toast('Success', `The annual review has been duplicated! ${response.id}`))
      //   .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    deleteFileFolder(filefolderId){
      this.$store.dispatch('filefolders/deleteFolder', { id: filefolderId })
        .then(response => this.toast('Success', `The annual review has been deleted! ${response.id}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    }
  }
}
</script>

<style scoped>

</style>
