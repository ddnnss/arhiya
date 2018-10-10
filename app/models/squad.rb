class Squad < ApplicationRecord
  has_many :players
  has_many :contracts

end
