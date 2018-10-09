class SquadController < ApplicationController
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
        s.update_column(:squad_recruting, true)
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
      p = Player.find_by_id(params[:player_id])
      if p.nil?
        redirect_to '/'
      else
        tmp = s.squad_in_request.split(',')
        tmp1 = tmp - [params[:player_id]]
        s.update_column(:squad_in_request , tmp1.join(','))
        p.update_column(:squad_id,params[:squad_id].to_i)
        UserMailer.squadapp(p.player_email).deliver_later
        m= Privatemessage.new
        m.player_id = s.squad_leader
        m.message_for_id = p.id
        m.message_text = 'Привет, ты добавлен в отряд.'
        m.save
        redirect_to '/profile/'+current_player.player_nickname_translit
      end

    end
  end

  def squaddel
    if current_player.squad_id == params[:squad_id].to_i
      s = Squad.find_by_id(params[:squad_id])
        if s
          s.destroy
          p = Player.where(:squad_id => params[:squad_id])
          p.each do |pp|
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
            ee.update_column(:event_squads,(ee.event_squads.split(',') -[params[:squad_id]]).join(','))
          end
          current_player.update_column(:squad_leader,false)
          redirect_to '/profile/'+current_player.player_nickname_translit
        else
          redirect_to '/'
        end
    else
      redirect_to '/'
    end

  end
  def squadedit
    if current_player.squad_id == params[:squad_id].to_i
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
    if current_player.squad_id == params[:squad_id].to_i
      p=Player.find(params[:player_id])
      p.update_column(:squad_id,nil)
      redirect_to '/profile/'+current_player.player_nickname_translit
    else
      redirect_to '/'
    end
  end

  def squaddeny
    if current_player.squad_id == params[:squad_id].to_i
     s = Squad.find(params[:squad_id])
     s.update_column(:squad_in_request,(s.squad_in_request.split(',') -[params[:player_id]]).join(','))

      redirect_to '/profile/'+current_player.player_nickname_translit
    else
      redirect_to '/'
    end
  end
end
