<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Upgrade Plan")
      .access-denied
        .access-denied-content
          .access-denied__logo
            img(src='/assets/svg/rocket.svg')
          h3.access-denied__title Upgrade to Access Feature
          p.access-denied__subtitle Choose a plan to get started!
          b-button.access-denied__btn(variant="dark") Check out plans
            b-icon.ml-2(icon="chevron-right")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Upgrade
</template>

<script>
  import AccessDenied from "@/common/AccessDenied"

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    components: { AccessDenied },
    data() {
      return {
        modalId: `modal_${rnd()}`,
      }
    },
    methods: {
      submit (e) {
        e.preventDefault();
        this.$emit('saved')
        this.$bvModal.hide(this.modalId)
      },
    },

  }
</script>
