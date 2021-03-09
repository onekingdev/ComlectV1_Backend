# frozen_string_literal: true

Rails.autoloaders.main.push_dir(Rails.root.join('lib'))
Rails.autoloaders.main.push_dir(Rails.root.join('lib/extensions'))
Rails.autoloaders.main.push_dir(Rails.root.join('lib/validators'))
