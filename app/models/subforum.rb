class Subforum < ApplicationRecord
  belongs_to :forum
  has_many :topics
  has_many :posts ,:through => :topics
end
