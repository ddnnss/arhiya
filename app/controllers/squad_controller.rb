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
end
