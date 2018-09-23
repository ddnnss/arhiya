class Event < ApplicationRecord
  serialize :players, JSON
end
