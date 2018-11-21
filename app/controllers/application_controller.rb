class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_player, :logged_in?, :player_pm, :player_admin, :player_banned

  def current_player

      return unless session[:player_id]
      @current_player ||= Player.find(session[:player_id])

  end

  def player_pm
    return unless session[:player_id]
    @player_pm = Privatemessage.where(message_for_id: current_player.id).order('created_at DESC')
  end

  def player_admin
    return unless session[:player_id]
    @player_admin = current_player.player_admin
  end

  def player_banned
    return unless session[:ban]
    @player_banned = true
  end


  def logged_in?

    !!session[:player_id]


  end
end
