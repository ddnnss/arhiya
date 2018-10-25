class Scumorder < ApplicationRecord
  serialize :order_items, JSON
end
