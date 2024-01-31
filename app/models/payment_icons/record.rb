# frozen_string_literal: true

module PaymentIcons
  class Record < FrozenRecord::Base
    self.base_path = File.expand_path("../../../db/", __dir__)
  end
end
