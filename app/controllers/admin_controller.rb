class AdminController < ApplicationController
before_action :ch_admin

def ch_admin
  if player_admin
  return true
  else
    redirect_to '/'
  end
end
def index
  @players = Player.all
  @squads = Squad.all


end

def squads
  @squads = Squad.all

end

def userinfo
  if params[:act].present?  && params[:act] == 'del'
    player = Player.find(params[:id])
    player.destroy!
    redirect_to '/admin/players'
  else
    @player = Player.find(params[:id])
  end


end
def adminuser
  p = Player.find(params[:p_id])
  p.update_column(:player_nickname,params[:player_nickname])
  p.update_column(:player_email,params[:player_email])
  p.update_column(:player_password,params[:player_password])
  p.update_column(:player_id,params[:player_id])
  p.update_column(:player_discord_link,params[:player_discord_link])
  p.update_column(:player_rank,params[:player_rank])
  p.update_column(:player_vk_link,params[:player_vk_link])
  p.update_column(:player_wallet,params[:player_wallet])
  if params[:player_activated]
    p.update_column(:player_activated,true)
  else
    p.update_column(:player_activated,false)
  end
  if params[:player_welcome_bonus]
    p.update_column(:player_welcome_bonus,true)
    else
    p.update_column(:player_welcome_bonus,false)
  end
  if params[:player_banned]
    p.update_column(:player_banned,true)
  else
    p.update_column(:player_banned,false)
  end

  p.save!

  redirect_to '/admin/players'


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

  def players
    if params[:bonus].present?
      p =Player.find(params[:bonus])
      p.update_column(:player_welcome_bonus, true)

    end
    if params[:sort].present?
    case params[:sort]
      when 'nick_asc'
        @players = Player.all.order('player_nickname ASC')
        @sort = 'nick_asc'
      when 'nick_desc'
        @players = Player.all.order('player_nickname DESC')
        @sort = 'nick_desc'
      when 'reg_asc'
        @players = Player.all.order('created_at ASC')
        @sort = 'reg_asc'
      when 'reg_desc'
        @players = Player.all.order('created_at DESC')
        @sort = 'reg_desc'
      when 'bonus_asc'
        @players = Player.all.order('player_welcome_bonus DESC')
        @sort = 'bonus_asc'
      when 'bonus_desc'
        @players = Player.all.order('player_welcome_bonus ASC')
        @sort = 'bonus_desc'
    end
    else
    @players = Player.all
    @sort = false
    end


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
    i=1
    @events.each do |e|
      if e.event_date.to_date < Date.today
        e.update_column(:event_active , false)
        e.update_column(:event_creator , '0')
      else
        e.update_column(:event_creator , i.to_s)
        i =i+1
      end
    end
    @event_type = ['Карта сокровищ','Освобождение заложника','Разведка','Исследования','Война роботов','Бегущие стволы','Бегущие стволы 2','Убей их всех','Штурм','Наемники',
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
    ee = Event.where(:event_active => true)
    e = Event.new
    e.event_creator = ee.count.next
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
      if params[:addforum][:forum_wiki] == '1'
        f.forum_wiki = true
      end

      f.save
    end
    if params[:addsub] == 'add'
      sf=Subforum.new
      sf.forum_id = params[:forum_id]
      sf.subforum_name = params[:addforum][:subforum_name]
      sf.subforum_name_translit = Translit.convert(params[:addforum][:subforum_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
      sf.subforum_icon = params[:subforum_icon]
      if sf.forum.forum_wiki
        sf.subforum_wiki =true
      end
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
