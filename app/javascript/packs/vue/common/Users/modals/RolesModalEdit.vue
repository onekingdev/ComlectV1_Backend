<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Role" @shown="getData")
      b-row
        .col
          .card
            .card-body
              .d-flex
                UserAvatar(:user="user" :bg="true")
                .d-block.m-l-2
                  h5.mt-2: b {{ user.first_name + ' ' +  user.last_name }}
                  p.mb-1 {{ user.state }}
                  StarsRating(:rate="Math.floor(Math.random() * 5)")
              hr
              ComboBox(v-model="form.role" :options="roleOptions" placeholder="Select a role")
              Errors(:errors="errors.role")
              .form-text.text-muted Determines the permissions the specialist will have access to

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import StarsRating from "../../../business/marketplace/components/StarsRating";

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: capitalize(id) })
  const capitalize = function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  }

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      user: {
        type: Object,
        required: true
      }
    },
    components: {
      StarsRating,
      UserAvatar,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: {},
        form: {
          role: '',
        }
      }
    },
    methods: {
      getData() {
        this.form.role = this.user.role
      },
      async submit (e) {
        e.preventDefault();
        this.errors = [];

        const data = {
          ...this.form
        }
        try {
          await this.$store.dispatch('settings/updateEmployee', data)
            .then((response) => {
              // console.log('response', response)
              if (response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  console.log(`${key}: ${value}`);
                  this.toast('Error', `${key}: ${value}`, true)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
                // console.log(this.errors)
                return
              }

              if (!response.errors) {
                this.toast('Success', "Changes have been saved.")
                this.$emit('saved')
                this.$bvModal.hide(this.modalId)
              }
            })
            .catch((error) => console.error(error))

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
    computed: {
      roleOptions() {
        return ['basic', 'trusted', 'admin'].map(toOption)
      }
    }
  }
</script>
