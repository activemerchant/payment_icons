# frozen_string_literal: true

module PaymentIcons
  class PaymentMethod < Record
    class UnknownIconVariationError < StandardError
      def initialize(variation_name)
        super("#{variation_name} doesn't exist")
      end
    end

    def default_icon_path
      "payment_icons/#{name}/default.svg"
    end

    def icon_variation_path(variation_name)
      path = "payment_icons/#{name}/#{variation_name}.svg"
      File.read("#{Engine::IMAGES_DIRECTORY}/#{variation_name}.svg")
      path
    rescue Errno::ENOENT
      raise UnknownIconVariationError, variation_name
    end

    def categories
      super.map do |category|
        Category.find_by_name(category)
      end
    end

    class << self
      def find_by_category_name(category_name)
        all.filter do |payment_method|
          payment_method.categories.any? do |category|
            category.name == category_name
          end
        end
      end
    end
  end
end
