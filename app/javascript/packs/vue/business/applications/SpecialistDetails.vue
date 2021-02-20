<template lang="pug">
  .row
    .col-sm-3
      UserAvatar(:user="specialist")
    .col-sm
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