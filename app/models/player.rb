class Player < ApplicationRecord
  serialize :player_shop_history, JSON
  serialize :player_cart, JSON
  has_many :topics
  has_many :privatemessages,:dependent => :destroy
  has_many :posts ,:through => :topics
  has_many :comments
  belongs_to :squad
  belongs_to :event

  validates :player_email,
            format: { with:/.+@.+\..+/i,message: 'Неправильный формат почты'},
            :uniqueness => {:message => 'Данный адрес уже зарегистрирован'}
  validates :player_id,
            :uniqueness => {:message => 'Данный STEAM ID уже зарегистрирован '},
            :presence => {:message => 'Не указан STEAM ID игрока '}
  validates :player_nickname,
            :uniqueness => {:message => 'Данный ник уже занят '},
            :presence => {:message => 'Не указан ник '}
  validates :player_discord_link,
            :uniqueness => {:message => 'Данный DiscordID уже занят '},
            :presence => {:message => 'Не указан DiscordID '}

  before_save :downcase_fields

  def downcase_fields
    self.player_email.downcase!
  end
end
