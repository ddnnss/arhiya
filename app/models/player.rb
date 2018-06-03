class Player < ApplicationRecord
  serialize :player_cart, JSON
  has_many :topics
  has_many :tarkovitems,:dependent => :destroy
  has_many :comments,:dependent => :destroy
  has_many :privatemessages,:dependent => :destroy
  has_many :posts ,:through => :topics

  validates :player_email,
            format: { with:/.+@.+\..+/i,message: 'Неправильный формат почты'},
            :uniqueness => {:message => 'Данный адрес уже зарегистрирован'}
  validates :player_nickname,
            :uniqueness => {:message => 'Данный ник уже занят '},
            :presence => {:message => 'Не указан ник '}

  before_save :downcase_fields

  def downcase_fields
    self.player_email.downcase!
  end
end
