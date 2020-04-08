# frozen_string_literal: true

# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

wkhtml_bin_path = if Rails.env.production? || Rails.env.staging?
                    ENV['WKHTMLTOPDF_PATH'] || '/usr/bin/wkhtmltopdf'
                  else
                    Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
                  end

WickedPdf.config = {
  # Path to the wkhtmltopdf executable: This usually isn't needed if using
  # one of the wkhtmltopdf-binary family of gems.
  # exe_path: '/usr/local/bin/wkhtmltopdf',
  #   or
  exe_path: wkhtml_bin_path
  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',
}
