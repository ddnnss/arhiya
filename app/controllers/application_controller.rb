class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_player, :logged_in?, :player_pm, :player_wh

  def current_player
    return unless session[:player_id]
    @current_player ||= Player.find(session[:player_id])
  end

  def player_pm
    return unless session[:player_id]
    @player_pm = Privatemessage.where(message_for_id: current_player.id)
  end

  def player_wh
    return unless session[:player_id]
    @player_wh = Whitelist.where(player_id: current_player.player_id)
  end

  def logged_in?
    !!session[:player_id]
  end
end
