const filters = {
  asDate: str => {
    const parts = str ? str.split('-').map(p => parseInt(p)) : null
    return parts ? `${parts[1]}/${parts[2]}/${parts[0]}` : ''
  }
}

export default filters