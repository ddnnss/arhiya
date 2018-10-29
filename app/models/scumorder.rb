class Scumorder < ApplicationRecord
  serialize :order_items, JSON
  belongs_to :player
end
