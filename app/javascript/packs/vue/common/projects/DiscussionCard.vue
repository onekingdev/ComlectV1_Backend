<template lang="pug">
  .card
    .card-header
      h3 Discussion
    Get(:messages="messagesUrl" :etag="etag"): template(v-slot="{messages}")
      .card-body(v-if="!messages.length")
        | No comments posted
        hr
      .card-body(v-else)
        div(v-for="message in messages" :key="message.id")
          p
            span.float-right {{ message.created_at | asDate }}
            | {{ message.message }}
          hr
    .card-body
      InputTextarea(v-model="comment.message" placeholder="Make a comment or leave a note..." :errors="commentErrors && commentErrors.message") Comment
      Post(v-bind="postCommentProps" @saved="commentSaved" @errors="commentErrors = $event")
        button.btn.btn-default Add Comment
</template>

<script>
import EtaggerMixin from '@/mixins/EtaggerMixin'

const DISCUSSION_UPDATE_PERIOD = 20000

export default {
  mixins: [EtaggerMixin()],
  props: {
    projectId: {
      type: Number,
      required: true
    },
    token: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      comment: { message: null },
      commentErrors: null
    }
  },
  created() {
    setInterval(this.newEtag, DISCUSSION_UPDATE_PERIOD)
  },
  methods: {
    commentSaved() {
      this.newEtag()
      this.toast('Success', 'Comment added')
      this.comment.message = null
    },
  },
  computed: {
    postCommentProps() {
      return {
        action: this.messagesUrl,
        model: { message: this.comment },
        headers: { Authorization: this.token },
      }
    },
    messagesUrl() {
      return `/api/local_projects/${this.projectId}/messages`
    },
  }
}
</script>