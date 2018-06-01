class Forum < ApplicationRecord
  has_many :subforums
  has_many :topics , :through => :subforums
  has_many :posts ,:through => :topics
end
