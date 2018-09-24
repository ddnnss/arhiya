class Event < ApplicationRecord
 # serialize :players, JSON
  has_many :players
  has_many :squads

end
