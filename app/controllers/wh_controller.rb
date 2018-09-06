class WhController < ApplicationController
  def addtowhitelist
    ww = Whitelist.find_by_player_id(params[:wh][:player_id])
    unless ww.blank?

      if ww.added
        flash[:wh_error] = 'Этот STEAM ID уже внеснен в whitelist сервера.'
      else
        flash[:wh_error] = 'Этот STEAM ID еще находится на рассмотрении.'
      end
      redirect_to request.referer
    else
      w = Whitelist.new

      w.player_id = params[:wh][:player_id]
      w.player_nick= params[:wh][:player_nick]
      w.player_email= params[:wh][:player_email]
      w.save
      UserMailer.newapply.deliver_later
      flash[:wh_send] = 'Заявка на внесение в WhiteList отправлена.'
      redirect_to root_path
    end

  end
end
