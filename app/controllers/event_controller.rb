class EventController < ApplicationController
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
  def index
  @current_week = []
  @next_week = []
  @event_time = ['00:00','01:00','02:00','03:00','04:00','05:00','06:00','07:00','08:00','09:00','10:00','11:00','12:00',
                 '13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00']
  @event_discord =['Приключения Тамриеля','Группа - 1','Группа - 2','Группа - 3','Группа - 4','Группа - 5','Группа - 6',
                   'Группа - 7','Группа - 8','Группа - 9','Группа - 10','Группа - 11','Группа - 12','Группа - 13',
                   'Триал - 1','Триал - 2','Спец. рейд','PvP','Имперский город','БГ']
  week_start = Date.today.beginning_of_week
    i=0
    7.times do
      @current_week.append(week_start+i)
      @next_week.append(Date.today.next_week + i)
      i = i+1
    end
  if params[:show] == 'next_week'
    @nw=true
    @current_week = @next_week
  end
@events1 = Event.where(:event_day => @current_week[0].strftime('%d/%m/%Y')).order('event_time asc')
  @events2 = Event.where(:event_day => @current_week[1].strftime('%d/%m/%Y')).order('event_time asc')
  @events3 = Event.where(:event_day => @current_week[2].strftime('%d/%m/%Y')).order('event_time asc')
  @events4 = Event.where(:event_day => @current_week[3].strftime('%d/%m/%Y')).order('event_time asc')
  @events5 = Event.where(:event_day => @current_week[4].strftime('%d/%m/%Y')).order('event_time asc')
  @events6= Event.where(:event_day => @current_week[5].strftime('%d/%m/%Y')).order('event_time asc')
  @events7= Event.where(:event_day => @current_week[6].strftime('%d/%m/%Y')).order('event_time asc')

  end

  def event_comment
  c = Comment.new
  p = Player.find(params[:event_creator])
  c.event_id = params[:event_id].to_i
    c.player_id = current_player.id
    c.comment_text = params[:event_comment][:comment]

  c.comment_rate=params[:review_rate]
    c.save
  cur_rating = p.player_votes_summ
  cur_votes_count = p.player_votes_count

  p.update_column(:player_votes_summ, cur_rating + params[:review_rate].to_i)
  p.update_column(:player_votes_count, cur_votes_count + 1)
    case params[:event_type]
      when 'tamriel_adv'
        redirect_to '/tamriel_adv_event_apply?event_id=' + params[:event_id]
      when 'dungeon'
      when 'trial'
      when 'sirodil'
      when 'bg_pvp'
      when 'guild_event'
    end



  end

  def tamriel_adv_event
    e = Event.new
    e.event_name = params[:tamriel_adv_event][:event_name]
    e.event_day = params[:event_day]
    e.event_time = params[:event_time]
    e.event_type = 'tamriel_adv'
    e.event_discord = params[:event_discord]
    e.event_creator = current_player.id
    unless params[:event_info] == ''
     e.event_info = params[:event_info]
    end
    e.save
    redirect_to '/events'

  end
  def tamriel_adv_event_apply
    unless params[:event_id].present?
      redirect_to '/events'
      return
    end
    @event= Event.find_by(id: params[:event_id])
    if @event.nil?
      redirect_to '/events'
    else
      @creator = Player.find(@event.event_creator)
      if logged_in?
      @event.event_tamriel_adventure_players.include?(current_player.id.to_s) ? @applyed = true : @applyed = false
      end
      @comments = Comment.where(event: params[:event_id])
      @players = Player.where(id: @event.event_tamriel_adventure_players)
      @similar = Event.where(event_type: 'tamriel_adv').order('event_time asc')
       if params[:apply].present?
          players = @event.event_tamriel_adventure_players.split(',')
          players.append(current_player.id.to_s)
          @event.update_column( :event_tamriel_adventure_players,  players.join(','))
          redirect_to '/tamriel_adv_event_apply/' + params[:event_id]
       end
      end
  end
  def dungeon_event
    e = Event.new
    e.event_name = params[:dungeon_event][:event_name]
    e.event_link = params[:dungeon_event][:event_link]
    e.event_day = params[:event_day]
    e.event_time = params[:event_time]
    e.event_type = 'dungeon'
    e.event_discord = params[:event_discord]
    e.event_creator = current_player.id
    pve_main_players = Hash.new
    pve_main_players[params[:event_pve_main_player1]] = ''
    pve_main_players[params[:event_pve_main_player2]] = ''
    pve_main_players[params[:event_pve_main_player2]] = ''

    unless params[:event_info] == ''
      e.event_info = params[:event_info]
    end
    e.save
    redirect_to events_path
  end

  def dungeon_event_apply
    unless params[:event_id].present?
      redirect_to '/events'
      return
    end
    @event= Event.find_by(id: params[:event_id])
    if @event.nil?
      redirect_to '/events'
    else
      @creator = Player.find(@event.event_creator)
      if logged_in?
        @event.event_pve_all_players.split(',').include?(current_player.player_nickname_translit) ? @applyed = true : @applyed = false
      end

      if @event.event_pve_main_player1.split(',').count == 2
        @main_player1_empty = false
        @main_player1_role = @event.event_pve_main_player1.split(',')[0]
        case @main_player1_role
          when 'tank'
            @role1_img = 'tank.png'
          when 'heal'
            @role1_img = 'heal.png'
          when 'dd'
            @role1_img = 'dd.png'
        end
        @main_player1_player = @event.event_pve_main_player1.split(',')[1]
        else
        @main_player1_empty = true
        @main_player1_role = @event.event_pve_main_player1.split(',')[0]
        case @main_player1_role
          when 'tank'
            @role1_img = 'tank.png'
          when 'heal'
            @role1_img = 'heal.png'
          when 'dd'
            @role1_img = 'dd.png'
        end

    end




      @comments = Comment.where(event: params[:event_id])
      @players = @event.event_tamriel_adventure_players.split(',')
      @similar = Event.where(event_type: 'dungeon').order('event_time asc')
      if params[:player].present?
        players = @event.event_tamriel_adventure_players.split(',')
        players.append(params[:player])
        @event.update_column( :event_tamriel_adventure_players,  players.join(','))
        redirect_to '/tamriel_adv_event_apply/' + params[:event_id]
      end
    end
  end





  def event_abort
    event= Event.find_by(id: params[:event_id])
    if event.nil?
      redirect_to '/events'
    else
    case params[:event_type]
     when '1'
      players = event.event_tamriel_adventure_players.split(',')
      players.delete(current_player.id.to_s)
      event.update_column( :event_tamriel_adventure_players,  players.join(','))
      redirect_to '/tamriel_adv_event_apply/' + params[:event_id]
    end
    end
  end
end
