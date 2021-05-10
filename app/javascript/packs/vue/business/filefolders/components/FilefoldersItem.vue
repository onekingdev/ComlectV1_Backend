<template lang="pug">
  tr
    td.align-middle
      a.link.d-flex.align-items-center(:href="itemType === 'file' ? item.file_addr : '#'" :target="itemType === 'file' ? '_blank' : '_self'" @click="openFolder($event, item.id, item.file_addr, item.name)")
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
          b-dropdown-item(v-if="item.locked" :disabled="item.locked" v-b-tooltip.hover.left="'Cant be edited!'") Edit
          FoldersModalEdit(v-else @editConfirmed="moveToFileFolder", :item="item", :inline="false")
            b-dropdown-item Edit
          b-dropdown-item(@click="downloadFileFolder(item.id)") Download
          b-dropdown-item(v-if="item.locked" :disabled="item.locked" v-b-tooltip.hover.left="'Cant be moved!'") Move to
          FoldersModalMoveTo(v-else @moveToConfirmed="moveToFileFolder", :item="item", :inline="false")
            b-dropdown-item Move to
          b-dropdown-item-button.delete(v-if="item.locked" :disabled="item.locked" variant='danger' v-b-tooltip.hover.left="'Cant be deleted!'" )
            <!--b-icon.mr-1(icon='x-circle' aria-hidden='true')-->
            | Delete
          FilefoldersModalDelete(v-else @deleteConfirmed="deleteFileFolder(item.id, itemType)" :inline="false")
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
