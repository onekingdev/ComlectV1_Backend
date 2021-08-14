<template lang="pug">
  .role-info
    ion-icon.role-info__icon(v-bind="curretnItemRole")
    span.ml-1 {{ role | capital }}
</template>

<script>
  export default {
    props: ['role'],
    computed: {
      curretnItemRole() {
        const role = this.role
        if (role === 'admin') {
          return {
            class: 'role-info__icon_admin',
            name: "people",
          }
        }
        if (role === 'trusted') {
          return {
            class: 'role-info__icon_trusted',
            name: "checkmark",
          }
        }
        if (role === 'basic') {
          return {
            class: 'role-info__icon_basic',
            name: "person-circle-outline",
          }
        }
      },
    }
  }
</script>

<style scoped>

</style>
