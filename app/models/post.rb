class Post < ApplicationRecord
  belongs_to :topic
  belongs_to :player
end
