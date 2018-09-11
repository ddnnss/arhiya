class WhController < ApplicationController
  def addtowhitelist

    nn1=params[:n1].to_i
    nn2=params[:n2].to_i
    nn3=params[:n3].to_i

    nn4=nn1+nn2
    if  nn3 == nn4
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
        flash[:steamid] = params[:wh][:player_id]
        if params[:reg] == 'on'


          pp = Player.find_by_player_email(params[:wh][:player_email])

          if pp.blank?
            @p = Player.new
            @p.player_password = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
            @p.player_email = params[:wh][:player_email]
            @p.player_nickname = params[:wh][:player_nick]
            @p.player_id = params[:wh][:player_id]
            @p.player_nickname_translit=Translit.convert(params[:wh][:player_nick].gsub(' ','-').gsub('ь','').gsub('ъ','').gsub(/[?!*.,:;\/`"']/, ''), :english)
            @p.save!
            UserMailer.activation(@p).deliver_later
            flash[:steamid] = params[:wh][:player_id]
            flash[:wh_reg_ok] = 'Аккаунт зарегистрирован. Письмо с инструкцией по активации отправлено (возможно оно попадет в спам)'
            flash[:wh_send] = 'Заявка на внесение в WhiteList отправлена.'
          else
            flash[:steamid] = params[:wh][:player_id]
            flash[:wh_send] = 'Заявка на внесение в WhiteList отправлена. '
            flash[:wh_reg_err] = 'Введеный адрес почты уже зарегистрирован в системе!'
          end





        end
        redirect_to '/'
      end
    else
      flash[:wh_error] = 'Неверный ответ'
      redirect_to request.referer
    end



  end
end
