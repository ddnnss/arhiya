class PlayerController < ApplicationController
  before_action :get_cart, :check_activity, :set_activity, :check_ban

  def check_ban
    if player_banned
      session[:active] = false
      reset_session
      flash[:ban] = 'Аккаунт заблокирован'
      redirect_to '/'
    end
  end

  def check_activity
    if logged_in?
      if current_player.updated_at + 1.hour < Time.now
        session[:active] = false
        reset_session
        redirect_to '/'
      end
    end
  end

  def set_activity
    if logged_in?
      current_player.update_column(:updated_at, Time.now)
    end
  end

  def get_cart

    if logged_in?
      if session[:cart].blank?
        session[:total] = 0
        logger.info('[INFO] : Корзина пуста.')
      else
        session[:total] = 0
        @cart= Scumitem.find(session[:cart].keys)

        logger.info('[INFO] : Корзина получена.')
      end


    end
  end


  def playerprofile
    @title = 'ПРОФИЛЬ ИГРОКА'
    @player = Player.find_by_player_nickname_translit(params[:player_nickname])
    unless @player
      redirect_to root_path
    else
      @stat = Playerstat.find_by_player_id(@player.player_id)
   # @comments = Comment.where(comment_for_id: @player.id).order('created_at desc')
    if logged_in? && @player.id == current_player.id
    #  @pm = Privatemessage.where(message_for_id: session[:player_id]).order('created_at desc')

      unless @player.squad_id.nil?
        if current_player.squad.squad_leader == current_player.id
          s = Squad.find(current_player.squad.id)
          if s.squad_in_request == ''
          @requests = false
          else
            @requests = true
            @req_players = Player.find(s.squad_in_request.split(','))
          end

          @sostav = Player.where(:squad_id => s.id)


        end
      end
      @players_events = Event.where('event_players LIKE "%?%"', @player.id).order('event_date asc')
    end

  end
  end
  def editplayer
    p=Player.find(session[:player_id])
    unless params[:editplayer][:player_avatar].blank?
      uploadedFile = params[:editplayer][:player_avatar]

      if File.file?(Rails.root.join('public','images','avatars', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end

      File.open(Rails.root.join('public','images','avatars',  uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      p.update_column(:player_avatar,uploadedFile.original_filename)
    end

    p.update_column(:player_vk_link,params[:player_vk_link])
    p.update_column(:player_password,params[:player_password])
    p.update_column(:player_discord_link,params[:player_discord_link])
    p.update_column(:player_info,params[:player_info])

    redirect_to '/profile/'+p.player_nickname_translit
  end

  def sendpm
      m= Privatemessage.new
      m.player_id = session[:player_id]
      m.message_for_id = params[:player_id]
      m.message_text = params[:sendpm][:message_txt]
      m.save

     # @p = Player.find(params[:tid])
     # if @p.notify
     #   UserMailer.pm(@p,params[:f],params[:message]).deliver_now
     # end
      respond_to do |format|
        @res='Неверный ответ'
        format.js
      end
  end
  def deletepm

    pm = Privatemessage.find(params[:pm_id])
    pm.destroy
    respond_to do |format|
      @pm_id = params[:pm_id]

      format.js
    end

  end
  def addcomment
    c = Comment.new
    p = Player.find(params[:review_for])
    if params[:reviewrate].present?
      c.comment_rate = params[:reviewrate]
    else
      c.comment_rate = '1'
    end
    rate = c.comment_rate.to_i
    p.update_column(:player_votes_count,p.player_votes_count + 1)
    p.update_column(:player_votes_summ,p.player_votes_summ + rate)
    c.player_id = session[:player_id]
    c.comment_for_id = p.id

    c.comment_text = params[:review_message]
    c.save

    redirect_to '/profile/'+p.player_nickname_translit

  end
  def login
    user = Player.find_by(player_email: params[:login][:player_email].downcase)
    if user             ##check user exists
      if user.player_activated ##check user activated
        if user.player_password == params[:login][:player_password]##check user password
          if user.player_banned
            session[:ban]=true
          end
          if user.player_temp2 == 'vip'
            session[:vip] = true
          end
          session[:player_id] = user.id
          session[:cart] = user.player_cart
          if user.player_temp1 == 'moder'
            session[:moder] = true
          end
          current_player.update_column(:updated_at, Time.now)
          user.update_column(:player_rating,user.player_rating.to_f + 0.00001)
          if user.player_lastlogin != Date.today
           user.update_column(:player_lastlogin,Date.today)

           if session[:vip]
             user.update_column(:player_wallet,user.player_wallet + (70 * user.player_rating.to_i))
           else
             user.update_column(:player_wallet,user.player_wallet + (30 * user.player_rating.to_i))
           end
          end

          if user.player_admin
            session[:admin] = true
            if user.player_rank == 'Новичек'
              user.update_column( :player_rank , 'CЕРВЕР-АДМИН')
            end
          end
          respond_to do |format|
            format.js {render inline: " window.location.reload()" }
          end
        else          ##wrong password
          respond_to do |format|
            @res = 'Неверный пaроль'
            format.js
          end           ##end respond
        end             ##end check user password
      else          ##user not activated
        respond_to do |format|
          @res = 'Аккаунт не активирован'
          format.js
        end           ##end respond
      end               ##end check user activated
    else              ##user not exists
      respond_to do |format|
        @res = 'Аккаунт не зарегистрирован'
        format.js
      end           ##end respond
    end                 ##end check user exists


  end
  def registration
    nn1=params.permit(:n1).to_h[:n1].to_i
    nn2=params.permit(:n2).to_h[:n2].to_i
    nn3=params.permit(:n3).to_h[:n3].to_i
    nn4=nn1+nn2
    if  nn3 == nn4    ##check captcha

      @user=Player.new(user_data)

      if @user.valid? ##check user
        @user.player_password = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
        @user.player_nickname_translit =Translit.convert(params[:registration][:player_nickname].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
        @user.player_last_v = Time.now - 1.day
        @user.player_last_zp = Time.now - 1.day
        @user.player_lastlogin = Date.today
        @user.player_rating = '1'
        @user.save

       UserMailer.activation(@user).deliver_later
        respond_to do |format|
          @res='Письмо с инструкцией по активации отправлено (возможно оно попадет в спам). Если письмо не придет в течении 15-30 минут, свяжитесь в дискорде с Грешником'
          @status = 'ok'
          format.js
        end           ##end respond

      else            ##user create error

        respond_to do |format|

          @res=@user.errors[:player_nickname][0].to_s + @user.errors[:player_email][0].to_s + @user.errors[:player_id][0].to_s + @user.errors[:player_discord_link][0].to_s


          format.js
        end           ##end respond

      end             ##end check user




    else             ## wrong answer

      respond_to do |format|
        @res='Неверный ответ'
        format.js
      end           ##end respond


    end               ##end check captcha



  end                     ##end create

  def destroy

    session[:active] = false
    reset_session
    redirect_to '/'
  end

  def activate
    u=Player.find_by(player_id: params[:player_id])
    if u.player_activated == false
      u.update_column(:player_activated,true)
      session[:player_id] = u.id
      session[:cart] = u.player_cart
      current_player.update_column(:updated_at, Time.now)
      u.update_column(:player_lastlogin, Date.today)
      flash[:activatesuccess] = 'Аккаунт активирован.'
      redirect_to '/'

    else
      flash[:activateerror] = 'Аккаунт уже активирован.'
      redirect_to '/'
    end
  end

private
  def user_data
    params.require(:registration).permit(:player_id,:player_email,:player_discord_link, :player_nickname)
  end

end
