<template lang="pug">
  .card.discussion
    .card-header
      h3.mb-0 Discussion
    Get(:messages="messagesUrl" :etag="etag"): template(v-slot="{messages}")
      .card-body.discussion__body(v-if="!messages.length")
        .d-flex.flex-column.justify-content-center.align-items-center
          ion-icon.discussion__icon.m-b-10(name="chatbox-ellipses-outline")
          p.discussion__text.mb-0 No comments posted
        hr
      .card-body(v-else)
        div(v-for="message in messages" :key="message.id")
          p.discussion__text.mb-0
            span.discussion__date.float-right {{ message.created_at | asDate }}
            | {{ message.message }}
          hr
    .card-body
      InputTextarea.m-b-20(v-model="comment.message" placeholder="Make a comment or leave a note..." :errors="commentErrors && commentErrors.message") Comment
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
