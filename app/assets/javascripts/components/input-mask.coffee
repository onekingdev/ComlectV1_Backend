$.onContentReady ($parent) ->
  $parent.find('[data-masked]').each ->
    $.initializeOnce $(this), 'input-mask', ($this) ->
      $this.mask $this.data('masked'), reverse: $this.data('reverse')

  $parent.find('[data-numeric]').each ->
    $.initializeOnce $(this), 'input-numeric', ($this) ->
      allowNegative = $this.data('allow-negative')
      allowDecimal = $this.data('allow-decimal')
      $this.keypress (e) ->
        isNumber e, $this.val(), allowNegative: allowNegative, allowDecimal: allowDecimal

isNumber = (e, string, opts) ->
  charCode = if e.which then e.which else e.keyCode
  opts ||= {}
  opts.allowNegative = if opts.allowNegative? then opts.allowNegative else false
  opts.allowDecimal = if opts.allowDecimal? then opts.allowDecimal else true

  existingDash = string.indexOf('-') != -1
  existingDot = string.indexOf('.') != -1
  checkDash = opts.allowNegative && charCode == 45 && !existingDash
  checkDot = opts.allowDecimal && charCode == 46 && !existingDot
  checkNumber = charCode >= 48 && charCode <= 57
  checkDash || checkDot || checkNumber
