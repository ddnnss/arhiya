class Forum < ApplicationRecord
  has_many :subforums, :dependent => :destroy
  has_many :topics , :through => :subforums, :dependent => :destroy
  has_many :posts ,:through => :topics, :dependent => :destroy
end
