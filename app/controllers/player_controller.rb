class PlayerController < ApplicationController
  def playerprofile
    @player = Player.find_by_player_nickname_translit(params[:player_nickname])
    if @player.player_votes_count != 0
      @rating = @player.player_votes_summ / @player.player_votes_count
    end


  end
  def addcomment
    c = Comment.new
    p = Player.find(params[:review_for])
    p.update_column(:player_votes_count,p.player_votes_count + 1)
    p.update_column(:player_votes_summ,p.player_votes_summ + params[:reviewrate].to_i)
    c.player_id = session[:player_id]
    c.comment_for_id = p.id
    c.comment_rate = params[:reviewrate]
    c.comment_text = params[:review_message]
    c.save

    redirect_to '/profile/'+p.player_nickname_translit

  end
  def login
    user = Player.find_by(player_email: params[:login][:player_email].downcase)
    if user             ##check user exists
      if user.player_activated ##check user activated
        if user.player_password == params[:login][:player_password]##check user password

          # if user.lastlogin != Date.today
          # user.lastlogin=Date.today
          #  user.wallet += 30
          # user.save
          # end


          session[:active] = true
          session[:player_nickname] = user.player_nickname
          session[:player_id] = user.id
          session[:player_vip] = user.player_vip
          user.update_column( :player_lastlogin , Date.today)




          if user.player_admin
            session[:admin] = true
            if user.player_rank == 'Новичек'

              user.update_column( :player_rank , 'Админ')

            end
          end

          if user.player_moder
            session[:moder] = true
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
        @user.player_nickname_translit =Translit.convert(params[:registration][:player_nickname].gsub(' ','-'), :english)

        @user.save

       # UserMailer.activation(@user).deliver_now

        respond_to do |format|
          @res='Письмо с инструкцией по активации отправлено (возможно оно попадет в спам)'
          @status = 'ok'
          format.js
        end           ##end respond

      else            ##user create error

        respond_to do |format|

          @res=@user.errors[:player_nickname][0].to_s + @user.errors[:player_email][0].to_s


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

private
  def user_data
    params.require(:registration).permit(:player_email, :player_nickname)
  end

end
