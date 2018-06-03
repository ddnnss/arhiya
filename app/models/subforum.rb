class Subforum < ApplicationRecord
  belongs_to :forum
  has_many :topics,:dependent => :destroy
  has_many :posts ,:through => :topics,:dependent => :destroy
end
