<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Upload file(s)")
      .row
        .col-12.m-y-1
          label.dropbox.w-100(for="files")
            input.input-file(type="file" id="files" ref="files" multiple accept="application/pdf" @change="selectFile")
            p Drag your file(s) here
              br
              | or
              br
              button.btn.btn-default.text-bold Upload File(s)
      .row
        .col-12
          .file-card(v-if="files" v-for="(file, key) in files")
            div.mr-2
              b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
            div.ml-0.mr-auto
              p.file-card__name: b {{ file.name }}
              .file-card__link.link Download
            div.ml-auto.align-self-start
              button.btn.btn__close.file-card__close(@click="removeFile(key)")
                b-icon(icon="x" font-scale="1")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Add
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      currentExamId: {
        type: Number,
        required: true
      },
      request: {
        type: Object,
        required: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        files: [],
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();

        if (!this.files.length) {
          this.makeToast('Error', `Please add minimal 1 file!`)
          return
        }

        // FOR SINGLE LOADING FILE
        // const params = {
        //   'file': this.files[0],
        // }
        //
        // let formData = new FormData()
        //
        // Object.entries(params).forEach(
        //   ([key, value]) => formData.append(key, value)
        // )

        // FOR MULTIPLE LOADING FILES
        let formData = new FormData()
        for( var i = 0; i < this.files.length; i++ ){
          let file = this.files[i];
          formData.append('file', this.files[i]);

          const data = {
            id: this.currentExamId,
            request: { id: this.request.id },
            formData
          }

          try {
            await this.$store.dispatch('exams/uploadExamRequestFile', data)
            this.makeToast('Success', `File successfull loaded!`)
            this.$emit('saved')
            this.$bvModal.hide(this.modalId)
          } catch (error) {
            this.makeToast('Error', error.message)
          }

        }
      },
      selectFile(event){
        // FOR SINGLE
        // this.files[0] = event.target.files[0]
        // this.files.push(event.target.files[0])

        // FOR MULTIPLE
        let uploadedFiles = this.$refs.files.files;
        /*
          Adds the uploaded file to the files array
        */
        for( var i = 0; i < uploadedFiles.length; i++ ){
          this.files.push( uploadedFiles[i] );
        }
      },
      removeFile(key){
        this.files.splice( key, 1 );
      }
    },
  }
</script>
