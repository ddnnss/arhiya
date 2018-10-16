class Contract < ApplicationRecord
  serialize :contract_reward, JSON
  serialize :contract_mission, JSON
  belongs_to :squad
end
