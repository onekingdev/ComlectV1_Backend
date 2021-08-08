<template lang="pug">
  div
    .messages.justify-content-center.align-items.center(v-if="!messages")
      h4 No Comments to Display
      p.mb-0 Type in the comment box below to get started
    .messages(v-if="messages")
      .message(v-for="(message, i) in messages" :key="i")
        .d-flex.align-items-start
          UserAvatar(:user="message.account", bgLight="true", size40="true")
          .d-block.text-left
            p.message__user-name {{ message.account.first_name }} {{ message.account.last_name }} commented.
            p.message__comment {{ message.comment }}
            .row
              .col-12
                .file-card(v-if="files" v-for="(file, key) in files")
                  div.mr-2
                    b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                  div.ml-0.mr-auto
                    p.file-card__name: b {{ file.name }}
                    .file-card__link.link Download
                  div.ml-auto.align-self-start
                    button.btn.btn__close.file-card__close(@click="removeFile(key)")
                      b-icon(icon="x" font-scale="1")
          .d-block.text-right.ml-auto
            p.message__date {{ message.date }}
</template>

<script>
    export default {
      data() {
        return {
          files: null,
          messages: [
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
          ]
        }
      },
    }
</script>

<style scoped>

</style>
