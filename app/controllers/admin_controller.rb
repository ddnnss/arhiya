class AdminController < ApplicationController
before_action :ch_admin

def ch_admin
  if player_admin
  return true
  else
    redirect_to '/'
  end
end

  def forum_admin
    @forum = Forum.all
    @icons = ['ion-help','ion-alert','ion-android-bulb','ion-ios-star','ion-beer','ion-android-chat','ion-alert-circled','ion-android-settings','ion-bonfire','ion-cash','ion-chatboxes','ion-coffee','ion-social-freebsd-devil','ion-speakerphone','ion-happy','ion-heart','ion-heart-broken','ion-help']
  end
  def addtopic
    @icons = ['ion-help','ion-alert','ion-android-bulb','ion-ios-star','ion-beer','ion-android-chat','ion-alert-circled','ion-android-settings','ion-bonfire','ion-cash','ion-chatboxes','ion-coffee','ion-social-freebsd-devil','ion-speakerphone','ion-happy','ion-heart','ion-heart-broken','ion-help']
    @subforum_id = params[:subforum_id]
    @topic_type = ['Первый взгляд','Обновление','Премьера','Патч','Гайд','Новости','Событие','Интересная тема']
  end


  def faq
    @faq = Faq.all
  end
  def addfaq
    f = Faq.new
    f.answer = params[:answer]
    f.question =params[:question]
    f.question_caps = params[:question].mb_chars.upcase
    if params[:link].present?
      f.link = params[:link]
    end
    f.save
    redirect_to '/admin/faq'

  end
  def events
    @events = Event.all
    @events.each do |e|
      if e.event_date.to_date < Date.today
        e.update_column(:event_active , false)
      end
    end
    @event_type = ['Война роботов','Бегущие стволы','Бегущие стволы 2','Убей их всех','Штурм','Наемники',
                   'Лучший стрелок','Побег','Ринг с зомби','Ринг с медведем','Бои на ринге (8угольник)','Ящики','Кулачный бой стенка-на-стенку']
    @event_time = ['00:00','01:00','02:00','03:00','04:00','05:00','06:00','07:00','08:00','09:00','10:00','11:00','12:00',
                   '13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00']
    @current_week = []
    week_start = Date.today.beginning_of_week
    i=0
    7.times do
      @current_week.append(week_start+i)

      i = i+1
    end


  end
  def addevent
    e = Event.new
    e.event_creator = current_player.id
    e.event_name = params[:event_name]
    e.event_time = params[:event_time]
    e.event_date = params[:event_date]
    e.event_info = params[:event_info]
    if params[:event_group].present?
      e.event_group = true
    end
    e.save
    redirect_to '/admin/events'

  end

  def eventinfo
    @event_info = Event.find_by_id(params[:id])

    @event_players = Player.where(:id => @event_info.event_players.split(',')).order('squad_id desc')
    @event_squads = Squad.where(id: @event_info.event_squads)

  end


  def addforum
    if params[:addmain] == 'add'
      f = Forum.new
      f.forum_name = params[:addforum][:forum_name]

      f.save
    end
    if params[:addsub] == 'add'
      sf=Subforum.new
      sf.forum_id = params[:forum_id]
      sf.subforum_name = params[:addforum][:subforum_name]
      sf.subforum_name_translit = Translit.convert(params[:addforum][:subforum_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
      sf.subforum_icon = params[:subforum_icon]
      sf.save
    end
    if params[:addmain] == 'edit'

    end
    if params[:addsub] == 'edit'

    end
    if params[:f_id].present?
      f = Forum.find(params[:f_id])
      f.destroy!

    end
    redirect_to admin_forum_path
  end
end
