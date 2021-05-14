<template lang="pug">
  Post(:action="url" method="PUT" :model="model" @saved="saved")
    b-form-checkbox(:checked="!hide_on_calendar") Show on Calendar
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      hide_on_calendar: this.project.hide_on_calendar
    }
  },
  methods: {
    async saved(response) {
      const kek = await response.json()
      this.hide_on_calendar = kek.hide_on_calendar
      this.toast('Saved', 'Saved')
    }
  },
  computed: {
    url() {
      return '/api/business/local_projects/' + this.project.id
    },
    model() {
      return { local_project: { hide_on_calendar: !this.hide_on_calendar }}
    }
  }
}
</script>