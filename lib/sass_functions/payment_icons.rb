# frozen_string_literal: true
require 'sassc'

module SassFunctions
  module PaymentIcons
    def payment_icons
      pattern = ::PaymentIcons::Engine.root.join('app', 'assets', 'images', 'payment_icons', '*.svg')
      icons = Dir.glob(pattern).map do |icon_path|
        icon_name = File.basename(icon_path, '.svg')
        svg_name = SassC::Script::Value::String.new(icon_name)
        class_name = SassC::Script::Value::String.new(icon_name.dasherize)

        SassC::Script::Value::List.new([svg_name, class_name], separator: :space)
      end

      SassC::Script::Value::List.new(icons, separator: :space)
    end
  end
end

module SassC::Script::Functions
  include SassFunctions::PaymentIcons
end
