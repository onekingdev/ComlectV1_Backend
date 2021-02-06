const redirectWithToast = (url, toast) => window.location.href = `${url}#toast=${encodeURIComponent(toast)}`

const extractToastMessage = () => {
  const match = window.location.hash.match(/#toast=(.+)/)
  if (match && match[1]) {
    history.replaceState(null, null, ' ')
    return decodeURI(match[1])
  }
}

export { redirectWithToast, extractToastMessage }