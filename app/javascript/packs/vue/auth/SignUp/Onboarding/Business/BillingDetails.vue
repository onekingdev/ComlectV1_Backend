<template lang="pug">
  div
    .card-header
      h5 title }}
      dl.row.m-t-2
        dt.col-sm-3 Location
        dd.col-sm-9 location }}
        dt.col-sm-3 Industry
        dd.col-sm-9 industries | names }}
        dt.col-sm-3 Start Date
        dd.col-sm-9 starts_on | asDate }}
        dt.col-sm-3 End Date
        dd.col-sm-9 ends_on | asDate }}
        dt.col-sm-3 Min. Experience
        dd.col-sm-9 minimum_experience | capital }}
        dt.col-sm-3 Description
        dd.col-sm-9 description }}
      p role_details }}
    .card-header
      h4.m-t-1 Skills
    .card-header
      h4.m-t-1 Client Details
</template>

<script>

export default {
  props: {
    project: {
    }
  },
  components: {
  }
}
</script>
