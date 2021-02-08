const filters = {
  asDate: str => {
    const parts = str ? str.split('-').map(p => parseInt(p)) : null
    return parts ? `${parts[1]}/${parts[2]}/${parts[0]}` : ''
  },
  usdWhole: int => {
    return `$ ${parseInt(int)}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
  }
}

export default filters