module PaymentIcons
  extend self

  def svgs
    directory = Pathname.new(File.join(File.dirname(File.expand_path(__FILE__)), '../app/assets/images/payment_icons/'))
    Dir[directory.join('*.svg')].map do |path|
      [File.basename(path, '.svg'), File.read(path).freeze]
    end.to_h.freeze
  end
end
