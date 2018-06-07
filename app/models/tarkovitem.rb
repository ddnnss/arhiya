class Tarkovitem < ApplicationRecord
  serialize :item_message_send_by, Array
  belongs_to :player
end
