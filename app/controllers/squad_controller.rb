class SquadController < ApplicationController
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
  def newsquad
    if params[:squad_action] == 'new'
      unless current_player.squad_id
        s = Squad.new
        uploadedFile = params[:squad][:squad_avatar]

        if File.file?(Rails.root.join('public','images','squads', uploadedFile.original_filename))
          uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
        end

        File.open(Rails.root.join('public','images','squads',  uploadedFile.original_filename), 'wb' ) do |f|
          f.write(uploadedFile.read)
        end

        s.squad_avatar = uploadedFile.original_filename
        s.squad_name = params[:squad][:squad_name]
        s.squad_rating = '1'
        s.squad_name_translit = Translit.convert(params[:squad][:squad_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english) + '-' + [*('a'..'z'),*('0'..'9')].shuffle[0,2].join
        s.squad_leader = current_player.id
        s.squad_info = params[:squad_info]
        if params[:squad][:squad_recruting] == '1'
          s.squad_recruting = true
        end
        s.save
        current_player.update_column(:squad_id , s.id)
        current_player.update_column(:squad_leader , true)
        ss = Squad.all
        i=1
        ss.each do |ss|
            ss.update_column(:squad_number , i)
            i =i+1
          end


        redirect_to '/profile/'+current_player.player_nickname_translit
      else
        redirect_to '/'
      end
    end
    if params[:squad_action] == 'update'
      s = Squad.find(params[:squad_id])
      if params[:squad][:squad_avatar].present?
        uploadedFile = params[:squad][:squad_avatar]

        if File.file?(Rails.root.join('public','images','squads', uploadedFile.original_filename))
          uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
        end

        File.open(Rails.root.join('public','images','squads',  uploadedFile.original_filename), 'wb' ) do |f|
          f.write(uploadedFile.read)
        end

        s.update_column(:squad_avatar ,uploadedFile.original_filename)

      end
      s.update_column(:squad_name ,params[:squad][:squad_name])
      s.update_column(:squad_name_translit ,Translit.convert(params[:squad][:squad_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english) + '-' + [*('a'..'z'),*('0'..'9')].shuffle[0,2].join)
      s.update_column(:squad_info, params[:squad_info])
      if params[:squad][:squad_recruting].present? && params[:squad][:squad_recruting] == '1'
        pp = Player.where(:squad_id =>params[:squad_id])
        if pp.count == 7
          s.update_column(:squad_recruting, false)
        else
          s.update_column(:squad_recruting, true)
        end

      else
        s.update_column(:squad_recruting, false)
      end
      redirect_to '/profile/'+current_player.player_nickname_translit
    end

  end

  def squadadd
    s = Squad.find_by_id(params[:squad_id])

    if s.nil?
      redirect_to '/'
    else
      pp = Player.where(:squad_id =>params[:squad_id])
      if pp.count == 7
        s.update_column(:squad_recruting , false)
        flash[:err] = 'Максимальное число игроков в отряде 7 чел.'
        redirect_to '/profile/'+current_player.player_nickname_translit
        else
          p = Player.find_by_id(params[:player_id])
          if p.nil?
            redirect_to '/'
          else


            if p.squad_id == nil
              p.update_column(:squad_id,params[:squad_id].to_i)

              ss = Squad.where('squad_in_request LIKE ?', '%'+params[:player_id]+'%')
              ss.each do |s|
                s.update_column(:squad_in_request , (s.squad_in_request.split(',') - [params[:player_id]]).join(','))

              end
              UserMailer.squadapp(p.player_email).deliver_later
              m= Privatemessage.new
              m.player_id = s.squad_leader
              m.message_for_id = p.id
              m.message_text = 'Привет, ты добавлен в отряд.'
              m.save
              if pp.count == 7
                s.update_column(:squad_recruting , false)
              end

              redirect_to '/profile/'+current_player.player_nickname_translit
            else
              s.update_column(:squad_in_request , (s.squad_in_request.split(',') - [params[:player_id]]).join(','))
              redirect_to '/'
            end



          end


      end





    end
  end

  def squaddel
    if player_admin

        s = Squad.find_by_id(params[:squad_id])
        if s
          p_ids=[]
          s.destroy
          p = Player.where(:squad_id => params[:squad_id])
          p.each do |pp|
            p_ids.append(pp.id.to_s)
            pp.update_column(:squad_id,nil)
          end
          ss = Squad.all
          i=1
          ss.each do |ss|
            ss.update_column(:squad_number , i)
            i =i+1
          end
          e=Event.where(:event_active =>true)
          e.each do |ee|
            if ee.event_group
              ee.update_column(:event_squads,(ee.event_squads.split(',') -[params[:squad_id]]).join(','))
              ee.update_column(:event_players,(ee.event_players.split(',') -  p_ids).join(','))
            end
          end
          current_player.update_column(:squad_leader,false)

            redirect_to '/admin/squads'


        end

    end
    if current_player.squad.squad_leader == current_player.id
      s = Squad.find_by_id(params[:squad_id])
        if s
          p_ids=[]
          s.destroy
          p = Player.where(:squad_id => params[:squad_id])
          p.each do |pp|
            p_ids.append(pp.id.to_s)
            pp.update_column(:squad_id,nil)
          end
          ss = Squad.all
          i=1
          ss.each do |ss|
            ss.update_column(:squad_number , i)
            i =i+1
          end
          e=Event.where(:event_active =>true)
          e.each do |ee|
            if ee.event_group
            ee.update_column(:event_squads,(ee.event_squads.split(',') -[params[:squad_id]]).join(','))
            ee.update_column(:event_players,(ee.event_players.split(',') -  p_ids).join(','))
            end
          end
          current_player.update_column(:squad_leader,false)
          if player_admin
            redirect_to '/admin/squads'
          else
            redirect_to '/profile/'+current_player.player_nickname_translit
          end

        else
          redirect_to '/'
        end
    else
      redirect_to '/'
    end

  end
  def squadedit
    if current_player.squad.squad_leader == current_player.id
      s = Squad.find_by_id(params[:squad_id])
      if s
        respond_to do |format|
          @squad_id = s.id
          @squad_name = s.squad_name
          @squad_img = s.squad_avatar
          @squad_rec = s.squad_recruting
          @squad_text = s.squad_info.html_safe
          format.js
        end

      else
        redirect_to '/'
      end
    else
      redirect_to '/'
    end
  end
  def squadkick
    if current_player.squad.squad_leader == current_player.id || player_admin
      p=Player.find(params[:player_id])
      p.update_column(:squad_id,nil)
      pp = Player.where(:squad_id =>params[:squad_id])
      if pp.count < 7
        current_player.squad.update_column(:squad_recruting , true)
        end
      if player_admin
        redirect_to request.referer
      else
        redirect_to '/profile/'+current_player.player_nickname_translit
      end

    else
      redirect_to '/'
    end
  end

  def squadnewleader
    if player_admin
      s = Squad.find(params[:squad_id])
      cur_leader = Player.find(s.squad_leader)
      new_leader = Player.find(params[:player_id])
      s.update_column(:squad_leader,new_leader.id)
      cur_leader.update_column(:squad_leader,false)
      new_leader.update_column(:squad_leader,true)
      redirect_to '/admin/squads'
    else
      redirect_to '/admin'
    end
  end

  def squaddeny
    if current_player.squad.squad_leader == current_player.id
     s = Squad.find(params[:squad_id])
     s.update_column(:squad_in_request,(s.squad_in_request.split(',') -[params[:player_id]]).join(','))

      redirect_to '/profile/'+current_player.player_nickname_translit
    else
      redirect_to '/'
    end
  end
  def squadleave
    current_player.update_column(:squad_id,nil)
    redirect_to '/profile/'+current_player.player_nickname_translit
  end
  def squadapply
    s = Squad.find_by_squad_name_translit(params[:squad_id])
    if s
      if s.squad_in_request.split(',').include? (current_player.id.to_s)
        flash[:s_error] = 'Заявка уже подана ранее.'
        redirect_to '/squads'
      else
        s.update_column(:squad_in_request,s.squad_in_request.split(',').append(current_player.id.to_s).join(','))

        m= Privatemessage.new
        m.player_id = current_player.id.to_s
        m.message_for_id = s.squad_leader.to_s
        m.message_text ='Заявка на вступление в отряд от <a href="http://www.gamescum.ru/profile/' + current_player.player_nickname_translit+'">' + current_player.player_nickname + '</a>'
        m.save
        flash[:s_success] = 'Заявка подана.'
        redirect_to '/squads'
      end

    else
      flash[:s_error] = 'Неведомая ошибка.'
      redirect_to '/squads'
    end
  end
end
