# frozen_string_literal: true
require 'sass'

module SassFunctions
  module PaymentIcons
    def payment_icons
      pattern = ::PaymentIcons::Engine.root.join('app', 'assets', 'images', 'payment_icons', '*.svg')
      icons = Dir.glob(pattern).map do |icon_path|
        icon_name = File.basename(icon_path, '.svg')
        svg_name = Sass::Script::Value::String.new(icon_name)
        class_name = Sass::Script::Value::String.new(icon_name.dasherize)

        Sass::Script::Value::List.new([svg_name, class_name], :space)
      end

      Sass::Script::Value::List.new(icons, :space)
    end
  end
end

module Sass::Script::Functions
  include SassFunctions::PaymentIcons
end
