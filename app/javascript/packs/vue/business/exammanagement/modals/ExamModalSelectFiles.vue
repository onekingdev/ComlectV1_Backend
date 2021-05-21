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
                    table.table.reviews-table(v-if="!filefolders.files && !filefolders.folders && !loading")
                      tbody
                        tr
                          td.text-center
                            h3 Documents not exist
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
          a.btn.link(@click="$bvModal.hide(modalId)") Cancel
          button.btn.btn-dark(@click="submit") Add
</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import FilefoldersTable from '@/business/filefolders/components/FilefoldersTable'
  import EtaggerMixin from '@/mixins/EtaggerMixin'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    mixins: [EtaggerMixin()],
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    components: {
      Loading,
      FilefoldersTable,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        countSelected: 0,
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
          // await this.$store.dispatch('exams/uploadExamRequestFile', data)
          this.makeToast('Success', `File successfull added!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
        } catch (error) {
          this.makeToast('Error', error.message)
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
          this.makeToast('Error', error.message)
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
          this.makeToast('Error', error.message)
        }
      },
      collecingFiles (value) {
        console.log('collecingFiles value', value)
        this.filesCollection.push(value)

        this.filesCollection.forEach(file => {
          if (file.id !== value.id) this.filesCollection.push(value)
        }, this)
        console.log('filesCollection', this.filesCollection)
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
    },
  }
</script>

