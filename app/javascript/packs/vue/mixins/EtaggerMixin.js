const etagInit = () => Math.random()

const EtaggerMixin = {
  data() {
    return {
      etag: etagInit()
    }
  },
  methods: {
    newEtag() {
      this.etag = etagInit()
    }
  }
}

export default EtaggerMixin