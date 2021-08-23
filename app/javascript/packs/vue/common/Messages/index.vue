<template lang="pug">
  div
    .messages.justify-content-center.align-items.center(v-if="!messages.length")
      h4 No Comments to Display
      p.mb-0 Type in the comment box below to get started
    .messages(v-if="messages && messages.length")
      .message(v-for="(message, i) in messages" :key="i" class="pb-0")
        .d-flex.align-items-start
          UserAvatar(:user="message.sender")
          .d-block.text-left
            p.message__user-name {{ message.sender.first_name }} {{ message.sender.last_name }} commented.
            p.message__comment(v-html="message.message")
            .row(:class="message.file_data ? 'm-t-10' : ''")
              template(v-if="message.file_data")
                .col-12(:class="message.file_data.length !== 1 ? 'm-b-1' : ''")
                  .file-card
                    div
                      b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                    div.ml-0.mr-auto
                      p.file-card__name {{ message.file_data.metadata ? message.file_data.metadata.filename : '' }}
                      a.file-card__link.link(:href="`/uploads/store/${message.file_data.id}`" target="_blank") Download
                    div.ml-auto.align-self-start.actions
                      b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                        template(#button-content)
                          b-icon(icon="three-dots")
                        b-dropdown-item.delete(@click="removeFile(message.id)") Delete file
          .d-block.text-right.ml-auto
            p.message__date {{ message.created_at | asDate }}
</template>

<script>
  import { DateTime } from 'luxon'
  var today = DateTime.now().toLocaleString(DateTime.DATE_FULL)

  export default {
    props: {
      messages: {
        type: Array,
        required: true
      }
    },
    data() {
      return {

      }
    },
    methods: {
      async removeFile(id, fileID) {

        const data = {
          id,
          file: { id: fileID },
        }
        // try {
        //   await this.$store.dispatch('reminders/deleteFile', data)
        //     .then(response => {
        //       this.toast('Success', `File successfull deleted!`)
        //     })
        //     .catch(error => this.toast('Error', error.message, true))
        // } catch (error) {
        //   this.toast('Error', error.message, true)
        // }
      },
      calcDate(vaue) {
        return today - vaue
      }
    }
  }
</script>

<style scoped>

</style>
