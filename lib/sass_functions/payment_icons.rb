# frozen_string_literal: true
require 'sass'

module Sass::Script::Functions
  include Sass::Script::Value::Helpers

  def payment_icons
    pattern = ::PaymentIcons::Engine.root.join('app', 'assets', 'images', 'payment_icons', '*.svg')
    icons = Dir.glob(pattern).map do |icon_path|
      icon_name = File.basename(icon_path, '.svg')

      list(quoted_string(icon_name), quoted_string(icon_name.dasherize), :space)
    end

    list(icons, :space)
  end
end
