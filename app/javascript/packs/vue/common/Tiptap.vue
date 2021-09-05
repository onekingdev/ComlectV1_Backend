<template lang="pug">
  div.editor(v-if="editor")
    div.editor-header
      template(v-for="(item, index) in items")
        div.divider(v-if="item.type === 'divider'" :key="`divider${index}`")
        button.menu-item(v-else :key="index" @click="item.action" :class="buttonClass(item.type, item.args)")
          i(:class="svgClass(item.icon)")
    EditorContent.editor-content(:editor="editor")
</template>

<script>
import 'remixicon/fonts/remixicon.css'
import { Editor, EditorContent } from '@tiptap/vue-2'
import StarterKit from '@tiptap/starter-kit'
import TaskList from '@tiptap/extension-task-list'
import TaskItem from '@tiptap/extension-task-item'
import Highlight from '@tiptap/extension-highlight'

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
      items: [
        {
          icon: 'bold',
          title: 'Bold',
          action: () => this.editor.chain().focus().toggleBold().run(),
          type: 'bold',
        },
        {
          icon: 'italic',
          title: 'Italic',
          action: () => this.editor.chain().focus().toggleItalic().run(),
          type: 'italic',
        },
        {
          icon: 'strikethrough',
          title: 'Strike',
          action: () => this.editor.chain().focus().toggleStrike().run(),
          type: 'strike',
        },
        {
          icon: 'code-view',
          title: 'Code',
          action: () => this.editor.chain().focus().toggleCode().run(),
          type: 'code',
        },
        {
          icon: 'mark-pen-line',
          title: 'Highlight',
          action: () => this.editor.chain().focus().toggleHighlight().run(),
          type: 'highlight',
        },
        {
          type: 'divider',
        },
        {
          icon: 'h-1',
          title: 'Heading 1',
          action: () => this.editor.chain().focus().toggleHeading({ level: 1 }).run(),
          type: 'heading',
          args: { level: 1 }
        },
        {
          icon: 'h-2',
          title: 'Heading 2',
          action: () => this.editor.chain().focus().toggleHeading({ level: 2 }).run(),
          type: 'heading',
          args: { level: 2 }
        },
        {
          icon: 'paragraph',
          title: 'Paragraph',
          action: () => this.editor.chain().focus().setParagraph().run(),
          type: 'paragraph',
        },
        {
          icon: 'list-unordered',
          title: 'Bullet List',
          action: () => this.editor.chain().focus().toggleBulletList().run(),
          type: 'bulletList',
        },
        {
          icon: 'list-ordered',
          title: 'Ordered List',
          action: () => this.editor.chain().focus().toggleOrderedList().run(),
          type: 'orderedList',
        },
        {
          icon: 'list-check-2',
          title: 'Task List',
          action: () => this.editor.chain().focus().toggleTaskList().run(),
          type: 'taskList',
        },
        {
          icon: 'code-box-line',
          title: 'Code Block',
          action: () => this.editor.chain().focus().toggleCodeBlock().run(),
          type: 'codeBlock',
        },
        {
          type: 'divider',
        },
        {
          icon: 'double-quotes-l',
          title: 'Blockquote',
          action: () => this.editor.chain().focus().toggleBlockquote().run(),
          type: 'blockquote',
        },
        {
          icon: 'separator',
          title: 'Horizontal Rule',
          action: () => this.editor.chain().focus().setHorizontalRule().run(),
        },
        {
          type: 'divider',
        },
        {
          icon: 'text-wrap',
          title: 'Hard Break',
          action: () => this.editor.chain().focus().setHardBreak().run(),
        },
        {
          icon: 'format-clear',
          title: 'Clear Format',
          action: () => this.editor.chain()
            .focus()
            .clearNodes()
            .unsetAllMarks()
            .run(),
        },
        {
          type: 'divider',
        },
        {
          icon: 'arrow-go-back-line',
          title: 'Undo',
          action: () => this.editor.chain().focus().undo().run(),
        },
        {
          icon: 'arrow-go-forward-line',
          title: 'Redo',
          action: () => this.editor.chain().focus().redo().run(),
        },
      ],
    }
  },
  mounted() {
    this.editor = new Editor({
      content: this.value,
      extensions: [
        StarterKit,
        TaskList,
        TaskItem,
        Highlight
      ],
      onUpdate: () => this.$emit('input', this.editor.getHTML()),
    })
  },
  methods: {
    getFocus() {
      return this.editor.chain().focus()
    },
    buttonClass(property, args) {
      if (!property) return ''
      return { 'is-active': this.editor.isActive(property, args) }
    },
    svgClass(type) {
      return `ri-${type}`
    },
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
.editor {
  display: flex;
  flex-direction: column;
  max-height: 26rem;
  color: #0D0D0D;
  background-color: #FFF;
  border: 3px solid #0D0D0D;
  border-radius: 0.75rem;
}

.editor-header {
  display: flex;
  align-items: center;
  flex: 0 0 auto;
  flex-wrap: wrap;
  padding: 0.25rem;
  border-bottom: 3px solid #0D0D0D;
}

.editor-content {
  padding: 1.25rem 1rem;
  flex: 1 1 auto;
  overflow-x: hidden;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}

.divider {
  width: 2px;
  height: 1.25rem;
  background-color: #0000001a;
  margin-left: 0.5rem;
  margin-right: 0.75rem;
}

.menu-item {
  width: 1.75rem;
  height: 1.75rem;
  color: #0D0D0D;
  border: none;
  background-color: transparent;
  border-radius: 0.4rem;
  padding: 0.25rem;
  margin-right: 0.25rem;
}

.is-active,
.menu-item:hover {
  color: #FFF;
  background-color: #0D0D0D;
}

.menu-item .svg {
  width: 100%;
  height: 100%;
  fill: currentColor;
}

/deep/ .ProseMirror blockquote {
  padding-left: 1rem;
  border-left: 2px solid rgba(13,13,13,.1);
}
</style>