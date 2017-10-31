module PaymentIcons
  class Engine < ::Rails::Engine
    isolate_namespace PaymentIcons

    initializer "payment_icons.assets.precompile" do |app|
      app.config.assets.precompile += %w(payment_icons/manifest.js)
    end
  end
end
