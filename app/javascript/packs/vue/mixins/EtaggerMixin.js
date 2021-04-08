const etagInit = () => Math.random()

const EtaggerMixin = propertyName => {
  const prop = propertyName || 'etag',
        refreshMethodName = 'new' + prop[0].toUpperCase() + prop.substring(1)
  return {
    data() {
      return {
        [prop]: etagInit()
      }
    },
    methods: {
      [refreshMethodName]: function() {
        this[prop] = etagInit()
      }
    }
  }
}

export default EtaggerMixin