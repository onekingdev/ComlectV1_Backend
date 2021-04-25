<template lang="pug">
  .card-body.white-card-body
    input(type="file" name="file" @change="onFileChanged")
    Get(:documents="url" :etag="etag"): template(v-slot="{documents}"): .row.p-x-1
      .alert.alert-info.col-md-4(v-for="document in documents" :key="document.id")
        p {{ document.file_data.metadata.filename }}
        p: a(:href='document.file_data.id') Download
</template>

<script>
import EtaggerMixin from '@/mixins/EtaggerMixin'

const uploadFile = async function(url, file) {
  const formData  = new FormData()
  formData.append('file', file)
  return await fetch(url, {
    method: 'POST',
    body: formData
  })
}

export default {
  mixins: [EtaggerMixin()],
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  methods: {
    async onFileChanged(event) {
      const file = event.target.files && event.target.files[0]
      if (file) {
        const success = (await uploadFile(this.url, file)).ok
        const message = success ? 'Document uploaded' : 'Document upload failed'
        this.toast('Document Upload', message, !success)
        this.newEtag()
      }
    }
  },
  computed: {
    url() {
      return `/api/projects/${this.project.id}/documents`
    }
  }
}
</script>