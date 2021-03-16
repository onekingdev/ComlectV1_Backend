<template lang="pug">
    div.policy-details-subsection
        .policy-details__name Subsection Name
        .d-flex
            b-icon.mr-2(icon='chevron-compact-right')
            input.policy-details__input(value="New Policy")
            .actions
                button.policy-details__btn.mr-3.btn.btn-default
                    b-icon.mr-2(icon='plus-circle-fill')
                    | Add Subsection
                button.btn
                    b-icon(icon="three-dots")
        .policy-details__name.mb-0 Description
        .policy-details__text-editor Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
</template>

<script>
export default {
  data() {},
};
</script>
