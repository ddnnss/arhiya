class AdminController < ApplicationController
  before_action :get_cart, :check_activity, :set_activity,:ch_admin
  require "csv"
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

## todo вывод баланса, лимит отряда 7чел

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
  def playerstat
    uploadedFileDeath = params[:stat][:stat_file_death]
    uploadedFileKills = params[:stat][:stat_file_kill]
    d=0
    k=0
    if File.file?(Rails.root.join('public','tmp', uploadedFileKills.original_filename))
      uploadedFileKills.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFileKills.original_filename
    end

    File.open(Rails.root.join('public','tmp',  uploadedFileKills.original_filename), 'wb' ) do |f|
      f.write(uploadedFileKills.read)
    end

    if File.file?(Rails.root.join('public','tmp', uploadedFileDeath.original_filename))
      uploadedFileDeath.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFileDeath.original_filename
    end

    File.open(Rails.root.join('public','tmp',  uploadedFileDeath.original_filename), 'wb' ) do |f|
      f.write(uploadedFileDeath.read)
    end

    CSV.foreach('public/tmp/' + uploadedFileDeath.original_filename) do |row|
      d=d+1
      p = Player.find_by_player_id(row[0].to_s.split(';')[0])
      if p
        stat = Playerstat.find_by_player_id(p.player_id)
          if stat
            if stat.player_nickname == 'Unknown'
              stat.update_column(:player_nickname, p.player_nickname)
            end
            stat.update_column(:player_deaths,stat.player_deaths + row[0].to_s.split(';')[1].to_i )
          else
            stat = Playerstat.new
            stat.player_nickname = p.player_nickname
            stat.player_id = p.player_id
            stat.player_deaths = row[0].to_s.split(';')[1].to_i
            stat.save
          end
      else
        stat = Playerstat.find_by_player_id(row[0].to_s.split(';')[0])
        if stat
          stat.update_column(:player_deaths,stat.player_deaths + row[0].to_s.split(';')[1].to_i )
        else
          stat = Playerstat.new
          stat.player_id = row[0].to_s.split(';')[0]
          stat.player_deaths = row[0].to_s.split(';')[1].to_i
          stat.save
        end
      end
      logger.info(row[0].to_s.split(';')[0]) #id
      logger.info(row[0].to_s.split(';')[1]) #death
    end

    CSV.foreach('public/tmp/' + uploadedFileKills.original_filename) do |row|
      k=k+1
      p = Player.find_by_player_id(row[0].to_s.split(';')[0])
      if p
        stat = Playerstat.find_by_player_id(p.player_id)
        if stat
          if stat.player_nickname == 'Unknown'
            stat.update_column(:player_nickname, p.player_nickname)
          end
          stat.update_column(:player_kills,stat.player_kills + row[0].to_s.split(';')[1].to_i )
        else
          stat = Playerstat.new
          stat.player_nickname = p.player_nickname
          stat.player_id = p.player_id
          stat.player_kills = row[0].to_s.split(';')[1].to_i
          stat.save
        end
      else
        stat = Playerstat.find_by_player_id(row[0].to_s.split(';')[0])
        if stat
          stat.update_column(:player_kills,stat.player_kills + row[0].to_s.split(';')[1].to_i )
        else
          stat = Playerstat.new
          stat.player_id = row[0].to_s.split(';')[0]
          stat.player_kills = row[0].to_s.split(';')[1].to_i
          stat.save
        end
      end
      logger.info(row[0].to_s.split(';')[0]) #id
      logger.info(row[0].to_s.split(';')[1]) #death
    end
    flash[:stat] = 'Обработано: смертей - ' + d.to_s + ' убийств - ' + k.to_s
    redirect_to '/admin'
  end



def shop
  @maincat = Scummaincat.all
end
def orders
  @orders = Scumorder.all.order('created_at DESC')

end
  def orderdelete
    o= Scumorder.find(params[:id])
    o.destroy
    redirect_to '/admin/orders'
  end
def order
  @order = Scumorder.find(params[:id])
  @items = Scumitem.find(@order.order_items.keys)
end
def ordercomplete
  o = Scumorder.find(params[:id])
  o.update_column(:order_complete , true)
  redirect_to '/admin/orders'
end

  def clearimg
    if params[:id] == 'players'
      avatars = []
      files = Dir.glob("#{Rails.root}/public/images/avatars/*").map{ |s| File.basename(s) }
      files = files - ['noavatar.png']
      logger.info('files : ' + files.inspect)
      users = Player.all
      users.each do |u|

        avatars.append(u.player_avatar)

      end
      logger.info('avatars : ' + avatars.inspect)
      filestodel = files - avatars
      logger.info('filestodel : ' + filestodel.inspect)
      filestodel.each do |f|
        File.delete("#{Rails.root}/public/images/avatars/"+f)
      end

    end
    redirect_to '/admin'
  end
def itemedit
  i = Scumitem.find(params[:item_id])
  respond_to do |format|
    @i_id =i.id
    @i_spawn = i.item_spawn_name
    @i_price = i.item_price
    @i_pp = i.item_squad_discount
    @i_name = i.item_name
    @i_img = i.item_image
    @i_show = i.item_show
    format.js
  end
end
def itemdel
  i = Scumitem.find(params[:item_id])
  i.destroy
  redirect_to '/admin/shop'
end
def addmaincat
  if params[:addmain] == 'add'
  c = Scummaincat.new
  c.cat_name = params[:addmaincat][:cat_name]
  c.cat_info = params[:addmaincat][:cat_info]
  c.cat_name_translit = Translit.convert(params[:addmaincat][:cat_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
  uploadedFile = params[:addmaincat][:cat_image]
  if File.file?(Rails.root.join('public','images','maincat', uploadedFile.original_filename))
    uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
  end
  File.open(Rails.root.join('public','images','maincat',  uploadedFile.original_filename), 'wb' ) do |f|
    f.write(uploadedFile.read)
  end
  c.cat_image = uploadedFile.original_filename
  if params[:addmaincat][:cat_show] == '0'
    c.cat_show = false
  end
  if params[:addmaincat][:cat_show] == '1'
    c.cat_show = true
  end
  c.save
  end
  if params[:addmain] == 'edit'
    c = Scummaincat.find(params[:main_id])
    unless params[:addmaincat][:cat_image] == ''
      uploadedFile = params[:addmaincat][:cat_image]
      if File.file?(Rails.root.join('public','images','maincat', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end
      File.open(Rails.root.join('public','images','maincat',  uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      c.update_column(:cat_image , uploadedFile.original_filename)
    end
    c.update_column(:cat_name , params[:addmaincat][:cat_name])
    c.update_column(:cat_info , params[:addmaincat][:cat_info])
    c.update_column(:cat_name_translit , Translit.convert(params[:addmaincat][:cat_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english))
    if params[:addmaincat][:cat_show] == '0'
      c.update_column(:cat_show , false)
    end
    if params[:addmaincat][:cat_show] == '1'
      c.update_column(:cat_show , true)
    end
  end

  redirect_to '/admin/shop'
end

def addscumitem
if params[:additem] == 'add'
  i = Scumitem.new
  i.scummaincat_id = params[:cat_id].to_i
  i.item_name = params[:addscumitem][:item_name]
  i.item_spawn_name = params[:addscumitem][:item_spawn_name]
  i.item_name_translit = Translit.convert(params[:addscumitem][:item_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
  uploadedFile = params[:addscumitem][:item_image]
  if File.file?(Rails.root.join('public','images','items', uploadedFile.original_filename))
    uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
  end
  File.open(Rails.root.join('public','images','items',  uploadedFile.original_filename), 'wb' ) do |f|
    f.write(uploadedFile.read)
  end
  i.item_image = uploadedFile.original_filename
  i.item_price = params[:addscumitem][:item_price].to_i
  i.item_squad_discount = params[:addscumitem][:item_squad_discount].to_i
  if params[:addscumitem][:item_show] == '0'
    i.item_show = false
  end
  i.save
end
if params[:additem] == 'edit'
  i = Scumitem.find(params[:item_id])
  unless params[:addscumitem][:item_image] == ''
    uploadedFile = params[:addscumitem][:item_image]
    if File.file?(Rails.root.join('public','images','items', uploadedFile.original_filename))
      uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
    end
    File.open(Rails.root.join('public','images','items',  uploadedFile.original_filename), 'wb' ) do |f|
      f.write(uploadedFile.read)
    end
    i.update_column(:item_image , uploadedFile.original_filename)
  end
  i.update_column(:item_price , params[:addscumitem][:item_price].to_i)
  i.update_column(:item_squad_discount , params[:addscumitem][:item_squad_discount].to_i)
  i.update_column(:item_name , params[:addscumitem][:item_name])
  i.update_column(:item_spawn_name , params[:addscumitem][:item_spawn_name])
  i.update_column(:item_name_translit , Translit.convert(params[:addscumitem][:item_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english))
  if params[:addscumitem][:item_show]== '0'
    i.update_column(:item_show , false)
  end
  if params[:addscumitem][:item_show]== '1'
    i.update_column(:item_show , true)
  end

end

  redirect_to '/admin/shop'
end

def editmaincat
  m = Scummaincat.find(params[:maincat_id])
  respond_to do |format|
    @mc_id = m.id
    @mc_info = m.cat_info
    @mc_name = m.cat_name
    @mc_img = m.cat_image
    @mc_show = m.cat_show
    format.js
  end
end

def ch_admin
  if player_admin || session[:moder]
  return true
  else
    redirect_to '/'
  end
end

def index
  @players = Player.all
  @squads = Squad.all

  @item = Scumitem.all.order('item_buys DESC')
  @cat = Scummaincat.all.order('cat_views DESC')
end

def squads
  @squads = Squad.all
end

def squad
  @squad = Squad.find(params[:id])
end

def updatesquad
  s = Squad.find(params[:squad_id])
  if params[:squadd][:squad_avatar] == ''
    else
    uploadedFile = params[:squadd][:squad_avatar]
    if File.file?(Rails.root.join('public','images','squads', uploadedFile.original_filename))
      uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
    end
    File.open(Rails.root.join('public','images','squads',  uploadedFile.original_filename), 'wb' ) do |f|
      f.write(uploadedFile.read)
     end
    s.update_column(:squad_avatar ,uploadedFile.original_filename)
  end
  s.update_column(:squad_name ,params[:squad_name])
  s.update_column(:squad_rating ,params[:squad_rating])
  s.update_column(:squad_name_translit ,Translit.convert(params[:squad_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english) + '-' + [*('a'..'z'),*('0'..'9')].shuffle[0,2].join)
  s.update_column(:squad_info, params[:squad_info])
  if params[:squad_recruting].present? && params[:squad_recruting] == '1'
    s.update_column(:squad_recruting, true)
  else
    s.update_column(:squad_recruting, false)
  end
  redirect_to '/admin/squads'
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
  if params[:player_vip]
    p.update_column(:player_temp2,'vip')
  else
    p.update_column(:player_temp2,'')
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

    def event
    end

    def addnewevent
      e = Eventtext.new
      uploadedFile = params[:event][:event_image]
      if File.file?(Rails.root.join('public','images','events', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end
      File.open(Rails.root.join('public','images','events',  uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      e.event_image = uploadedFile.original_filename
      e.event_name = params[:event][:event_name]
      e.event_info = params[:event_info]
      e.save
      redirect_to '/admin/event'
    end

def contracts
  @contracts = Contract.all
end

def addnewcontract
  c = Contract.new
  d={}
  o={}
  uploadedFile = params[:contract][:contract_image]
  if File.file?(Rails.root.join('public','images','contracts', uploadedFile.original_filename))
    uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
  end
  File.open(Rails.root.join('public','images','contracts',  uploadedFile.original_filename), 'wb' ) do |f|
    f.write(uploadedFile.read)
  end
  c.contract_image = uploadedFile.original_filename
  c.contract_name = params[:contract][:contract_name]
  c.contract_info = params[:contract_info]
  c.contract_duration = params[:contract_duration]
  temp = params[:contract][:contract_reward].split(',')
    temp.each do |t|
      d[t.split('-')[0]]=t.split('-')[1]
    end
  c.contract_reward = d
  if params[:contract_hh].present?
    c.contract_hh = true
    c.contract_hh_player = params[:contract][:contract_hh_player]
  else
    temp = params[:contract][:contract_mission].split(',')
    temp.each do |t|
      o[t.split('-')[0]]=t.split('-')[1]
    end
    c.contract_mission =o
  end
  c.save
  redirect_to '/admin/contracts'
end

  def events
    @event_type = Eventtext.all
    if params[:id].present?
      @current_event = Eventtext.find(params[:id])
    else
      @current_event = Eventtext.first
    end
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
   # @event_type = ['Карта сокровищ','Освобождение заложника','Разведка','Исследования','Война роботов','Бегущие стволы','Бегущие стволы 2','Убей их всех','Штурм','Наемники',
   #                'Лучший стрелок','Побег','Ринг с зомби','Ринг с медведем','Бои на ринге (8угольник)','Ящики','Кулачный бой стенка-на-стенку']
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

  def deleteevent
    e = Event.find(params[:id])
    e.destroy
    redirect_to '/admin/events'
  end

  def addevent
    ee = Event.where(:event_active => true)
    e = Event.new
    e.event_creator = ee.count.next
    e.event_name = params[:event_name]
    e.event_time = params[:event_time]
    e.event_date = params[:event_date]
    e.event_info = params[:event_info]
    e.event_image = params[:event_image]
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
