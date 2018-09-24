class Squad < ApplicationRecord
  has_many :players
  belongs_to :event
end
