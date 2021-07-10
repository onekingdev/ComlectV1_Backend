<template lang="pug">
  .row
    .col-sm-2.pr-0
      UserAvatar(:user="specialist")
    .col-sm.pl-0
      h3 {{ specialist.first_name }} {{ specialist.last_name }}
      p {{ specialist.address_1 }} {{ specialist.address_2 }}
      StarRating(:stars="4")
</template>

<script>
export default {
  props: {
    specialist: {
      type: Object,
      required: true
    }
  }
}
</script>
