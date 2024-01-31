class PaymentIcon < FrozenRecord::Base
  self.base_path = File.expand_path('../../db/', __dir__)

  GROUPS = {
    credit_cards: 'Credit cards',
    cryptocurrencies: 'Digital currencies',
    bank_transfers: 'Bank transfers',
    wallets: 'Digital wallets',
    convenience_stores: 'Convenience Stores',
    other: 'Other'
  }

  def path
    "payment_icons/#{name}/default.svg"
  end

  class << self
    def find_by_group(group)
      where(group: group)
    end

    def credit_cards
      where(group: 'credit_cards')
    end

    def cryptocurrencies
      where(group: 'cryptocurrencies')
    end

    def bank_transfers
      where(group: 'bank_transfers')
    end

    def wallets
      where(group: 'wallets')
    end

    def convenience_stores
      where(group: 'convenience_stores')
    end
  end
end
