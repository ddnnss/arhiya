class Topic < ApplicationRecord
  belongs_to :subforum
  belongs_to :player
  has_many :posts

end
