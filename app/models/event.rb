class Event < ApplicationRecord
  has_many :comments,:dependent => :destroy
  serialize :event_pve_main_players, JSON
  serialize :event_pve_add_players, JSON
end
