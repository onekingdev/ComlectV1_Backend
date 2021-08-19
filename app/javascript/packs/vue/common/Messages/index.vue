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
                .col-12(:class=" message.file_data.length !== 1 ? 'm-b-1' : ''")
                  .file-card
                    div
                      b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                    div.ml-0.mr-auto
                      p.file-card__name {{ message.file_data.metadata ? message.file_data.metadata.filename : '' }}
                      a.file-card__link.link(:href="message.file_data.id" target="_blank") Download
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
        account: {
          first_name: 'John',
          last_name: 'Doe',
        },
        // messages: [
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago',
        //     files: [
        //       {
        //         id: 1,
        //         name: 'updated_document.pdf',
        //         file_url: '#'
        //       }
        //     ],
        //   },
        //   {
        //     account: {
        //       first_name: 'Johnny',
        //       last_name: 'Appleseed',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '20 hours ago'
        //   },
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago'
        //   },
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago'
        //   },
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago'
        //   },
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago'
        //   },
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago',
        //     files: [
        //       {
        //         id: 1,
        //         name: '1updated_document.pdf',
        //         file_url: '#'
        //       },
        //       {
        //         id: 2,
        //         name: '2updated_document.pdf',
        //         file_url: '#'
        //       },
        //       {
        //         id: 3,
        //         name: '3updated_document.pdf',
        //         file_url: '#'
        //       }
        //     ],
        //   },
        //   {
        //     account: {
        //       first_name: 'John',
        //       last_name: 'Doe',
        //     },
        //     comment: 'Could you attach the updated document?',
        //     date: '10 hours ago'
        //   }
        // ]
      }
    },
    methods: {
      async removeFile(id, fileID) {

        const data = {
          id,
          file: { id: fileID },
        }

        try {
          await this.$store.dispatch('reminders/deleteFile', data)
            .then(response => {
              this.toast('Success', `File has been deleted.`)
            })
            .catch(error => this.toast('Error', error.message, true))
        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
      calcDate(vaue) {
        return today - vaue
      }
    }
  }
</script>

<style scoped>

</style>
