class SquadController < ApplicationController
  def newsquad
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

    redirect_to '/profile/'+current_player.player_nickname_translit


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
end
