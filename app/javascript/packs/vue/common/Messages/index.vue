<template lang="pug">
  div
    .messages.justify-content-center.align-items.center(v-if="!messages.length")
      h4 No Comments to Display
      p.mb-0 Type in the comment box below to get started
    .messages(v-if="messages && messages.length")
      .message(v-for="(message, i) in messages" :key="i")
        .d-flex.align-items-start
          UserAvatar(:user="message.account", :bgLight="true", :size40="true")
          .d-block.text-left
            p.message__user-name {{ message.account.first_name }} {{ message.account.last_name }} commented.
            p.message__comment {{ message.comment }}
            .row(:class="message.files ? 'm-t-10' : ''")
              template(v-for="(file, fileIndex) in message.files")
                .col-12(:key="fileIndex" :class=" message.files.length !== 1 ? 'm-b-1' : ''")
                  .file-card
                    div
                      b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                    div.ml-0.mr-auto
                      p.file-card__name {{ file.name }}
                      a.file-card__link.link(:href="file.file_url" target="_blank") Download
                    div.ml-auto.align-self-start.actions
                      b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                        template(#button-content)
                          b-icon(icon="three-dots")
                        b-dropdown-item.delete(@click="removeFile(file.id)") Delete file
          .d-block.text-right.ml-auto
            p.message__date {{ message.date }}
</template>

<script>
  // import messages from './messages.json'

  export default {
    data() {
      return {
        messages: [
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago',
            files: [
              {
                id: 1,
                name: 'updated_document.pdf',
                file_url: '#'
              }
            ],
          },
          {
            account: {
              first_name: 'Johnny',
              last_name: 'Appleseed',
            },
            comment: 'Could you attach the updated document?',
            date: '20 hours ago'
          },
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago'
          },
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago'
          },
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago'
          },
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago'
          },
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago',
            files: [
              {
                id: 1,
                name: '1updated_document.pdf',
                file_url: '#'
              },
              {
                id: 2,
                name: '2updated_document.pdf',
                file_url: '#'
              },
              {
                id: 3,
                name: '3updated_document.pdf',
                file_url: '#'
              }
            ],
          },
          {
            account: {
              first_name: 'John',
              last_name: 'Doe',
            },
            comment: 'Could you attach the updated document?',
            date: '10 hours ago'
          }
        ]
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
    }
  }
</script>

<style scoped>

</style>
