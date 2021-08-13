<template lang="pug">
  .row.py-2
    .col-lg-2.col-3
      b-img(width="100" height="100" class="m1" rounded="circle" alt="image_desc" :src="specialist.photo ? specialist.photo : `https://loremflickr.com/100/100/cat?lock=${specialist.id}`")
    .col-lg-10.col-9
      .row
        .col-md-9.col
          h3.m-b-1
            a.link(:href="specialist.resume_url" @click="openDetails(project.id)" target="_blank") {{ specialist.first_name }} {{ specialist.last_name }}
          h6.pb-1.card-subtitle.text-muted.mb-2  {{ specialist.location }} |
          .d-inline(v-if="specialist.industries" v-for="ind in specialist.industries") &nbsp;{{ ind.name }}&nbsp;
          .d-flex.py-2
            StarsRating(:rate="Math.floor(Math.random() * 5)")
          .d-flex.py-2
          .badge.badge-default.m-r-1 Auditing
          .badge.badge-default.m-r-1 Compilance Reporting
          .badge.badge-default.m-r-1 Mock Interviews
        .col-md-3.col.justify-content-end
          .d-flex.align-items-center.justify-content-lg-end
            b-icon.linkedin.mr-3(icon='linkedin' font-scale="1.5")
            b-button(variant="default" @click="$emit('directMessage')") Message
    .offset-lg-2.col-lg-10.col
      b-card-text.m-t-1(v-if="specialist.description") {{specialist.description}}
      b-card-text.m-t-1(v-else)
      | Hi, my name Chris Jakson Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
      | laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
      .d-flex.justify-content-between
      SpecialistFigures(:specialist="specialist")
</template>

<script>
import SpecialistFigures from './SpecialistFigures'
import StarsRating from './StarsRating'

export default {
  name: 'SpecialistPanel',
  components: {
    SpecialistFigures,
    StarsRating
  },
  props: {
    specialist: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      experienceOptions: ['Junior', 'Intermediate', 'Expert'],
    }
  }
}
</script>
