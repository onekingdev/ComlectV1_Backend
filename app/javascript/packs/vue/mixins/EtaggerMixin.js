const etagInit = () => Math.random()

const EtaggerMixin = {
  data() {
    return {
      etag: etagInit()
    }
  },
  methods: {
    refetch() {
      this.etag = etagInit()
    }
  }
}

export default EtaggerMixin