<template lang="pug">
  div(v-if="editor")
    button(@click="getFocus().toggleBold().run()" :class="buttonClass('bold')") Bold
    button(@click="getFocus().toggleItalic().run()" :class="buttonClass('italic')") Italic
    br
    button(@click="getFocus().toggleOrderedList().run()" :class="buttonClass('orderedList')") Ordered List
    button(@click="getFocus().toggleBulletList().run()" :class="buttonClass('bulletList')") Bullet list
    br
    button(v-for="level in [1,2,3,4,5,6]" @click="getFocus().toggleHeading({level}).run()" :class="buttonClass('heading', {level})" :key="level") H{{level}}
    EditorContent(:editor="editor")
</template>

<script>
import { Editor, EditorContent } from '@tiptap/vue-2'
import StarterKit from '@tiptap/starter-kit'

export default {
  props: {
    value: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      editor: null,
    }
  },
  mounted() {
    this.editor = new Editor({
      content: this.value,
      extensions: [
        StarterKit,
      ],
      onUpdate: () => this.$emit('input', this.editor.getHTML()),
    })
  },
  methods: {
    getFocus() {
      return this.editor.chain().focus()
    },
    buttonClass(property, args) {
      return { 'is-active': this.editor.isActive(property, args) }
    }
  },
  watch: {
    value(value) {
      if (this.editor.getHTML() !== value) {
        this.editor.commands.setContent(value, false)
      }
    },
  },

  beforeDestroy() {
    this.editor.destroy()
  },
  components: {
    Editor,
    EditorContent,
  },
}
</script>

<style scoped>
.is-active {
  font-weight: 800;
}
</style>