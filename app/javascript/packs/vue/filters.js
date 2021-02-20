const filters = {
  asDate: str => {
    const parts = str ? str.split('-').map(p => parseInt(p)) : null
    return parts ? `${parts[1]}/${parts[2]}/${parts[0]}` : ''
  },
  usdWhole: int => {
    return `$ ${parseInt(int)}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
  },
  names: arr => arr.map(({ name }) => name).join(', '),
  plural: (name, items) => {
    const quantity = Array.isArray(items) ? items.length : items
    return `${quantity} ${name}` + (1 === quantity ? '' : 's')
  }
}

export default filters