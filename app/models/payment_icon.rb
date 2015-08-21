class PaymentIcon < FrozenRecord::Base

  self.base_path = File.expand_path('../../db/', __dir__)

  def self.path(name)
    "payment_icons/#{name}.svg"
  end

  def self.find_by_group(group)
    where(group: group)
  end

  def self.credit_cards
    where(group: 'credit_cards')
  end

  def self.cryptocurrencies
    where(group: 'cryptocurrencies')
  end

end
