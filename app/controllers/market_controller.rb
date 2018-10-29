class MarketController < ApplicationController
  before_action :get_cart, except: [:placeorder]


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

  def placeorder
    if session[:total] == 0
      logger.info('[INFO] : Сумма заказа = 0')
      logger.info('[INFO] : session[:total] = ' + session[:total].to_s)
      redirect_to '/blackmarket'
      flash[:err] = 'Нет товаров для оплаты'
    else
      if current_player.player_wallet < session[:total].to_i
        logger.info('[INFO] : Не хватает денег')
        flash[:err] = 'Не хватает денег. Сумма заказа : ' +session[:total].to_s + ' RC . Твой баланс : ' + current_player.player_wallet.to_s + ' RC'
        redirect_to '/blackmarket'
      else
        o = Scumorder.new
        o.player_id = current_player.id
        o.order_items = session[:cart]
        o.order_total_price = session[:total].to_i
        o.save
        a=session[:cart].keys
        a.each do |k|
          session[:cart].delete(k)
        end

        current_player.update_column(:player_wallet, current_player.player_wallet - session[:total].to_i)
        current_player.update_column(:player_cart,nil)

        a = Player.where(:player_admin => true)
        a.each do |p|
          m= Privatemessage.new
          m.player_id = current_player.id.to_s
          m.message_for_id = p.id.to_s
          m.message_text ='Привет, я сделал заказ в магазине'
          m.save
          UserMailer.neworder(p.player_email).deliver_later
        end
        redirect_to '/blackmarket'
        flash[:ok] = 'Заказ размещен. Администрация свяжется с тобой в дискорде по поводу выдачи.'

      end
    end

  end

  def removecart
    if params[:item_id].present?
    session[:cart].delete(params[:item_id])
    current_player.update_column(:player_cart , session[:cart])
    end
    redirect_to request.referer
    logger.info('[INFO] : Товар удален из корзины.')

  end

  def index
 @scummaincat = Scummaincat.where(:cat_show => true)

  end

  def showcat
    cat = Scummaincat.find_by_cat_name_translit(params[:cat_name_translit])
    @items = cat.scumitems.all
  end

  def addtocart
    item = Scumitem.find(params[:item_id])




      if session[:cart].nil?  #корзина существует?
        logger.info('[INFO] : Инициализация корзины. Обработка ......')
        session[:cart]=Hash.new
        session[:cart][item.id] = 1
        @duplicate = false
        current_player.update_column(:player_cart , session[:cart])

      else
        if session[:cart].key? item.id.to_s #проверка дублирования товара в корзине
          logger.info('[INFO] : Существующий товар. Обработка ......')

          session[:cart][item.id.to_s] = session[:cart][item.id.to_s].to_i + 1
          current_player.update_column(:player_cart , session[:cart])
          @duplicate = true
        else
          logger.info('[INFO] : Новый товар. Обработка ......')

          session[:cart][item.id] = 1
          current_player.update_column(:player_cart , session[:cart])
          @duplicate = false
        end

      end





    if @duplicate               #дупликата товара
      session[:total] = session[:total] + item.item_price * session[:cart][item.id.to_s]
      respond_to do |format| # дупликат товара
        @dup = @duplicate
        @item_id = item.id
        @item_name = item.item_name
        @item_count = session[:cart][item.id.to_s]

        @item_total = item.item_price * session[:cart][item.id.to_s]
        @item_price = item.item_price
        @item_total_price = @item_price * @item_count




        logger.info('[INFO] : Существующий товар обновлен.')
        format.js
      end

    else
      session[:total] = session[:total] + item.item_price
      respond_to do |format| #нет дупликата товара
        @dup = @duplicate

        @item_id = item.id
        @item_name = item.item_name
        @item_name_translit = item.item_name_translit
        @item_image = item.item_image
        @item_price = item.item_price
        logger.info('[INFO] : Новый товар добавлен в корзину.')
        format.js
      end

    end




  end

  def newtarkovitem
    p = Player.find(session[:player_id])
    if params[:item_info] ==''
      flash[:error] = 'Необходимо ввести информацию о товаре.'
      redirect_to '/profile/' + p.player_nickname_translit
    else
      i = Tarkovitem.new

      i.player_id = session[:player_id]
      i.item_name = params[:item_name]
      i.item_name_caps = params[:item_name].mb_chars.upcase
      i.item_name_translit = Translit.convert(params[:item_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
      i.item_tags = params[:item_name].gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',').mb_chars.upcase
      i.item_type = params[:item_tag][:item_tag_id]
      i.item_to_sell_count = params[:item_to_sell_count].to_i
      i.item_price_virt_rub = params[:item_price_virt_rub].to_i
      i.item_info = params[:item_info]

      i.item_price_virt_usd = params[:item_price_virt_usd].to_i
      i.item_price_virt_eur = params[:item_price_virt_eur].to_i
      p.update_column(:player_sells_count, p.player_sells_count + 1)
      if params[:item_barter_checkbox] == 'on'
        i.item_barter_for = params[:item_barter]
        i.item_barter = true
      end
      if session[:admin] || session[:vip]
        i.item_vip = true
        i.item_price_real_rub = params[:item_price_real_rub].to_i
      end
      i.save
      flash[:ок] = 'Товар выставлен на продажу.'
      redirect_to '/profile/' + p.player_nickname_translit
    end

  end

  def tarkovmarket
    @item_tags = {'Игровая валюта': 1,'Оружие': 2,'Квестовые предметы': 3,'Предметы на обмен': 4,'Снаряжение и одежда': 5,
                  'Модули и магазины': 6,'Ценные предметы': 7,'Контейнеры и кейсы': 8,'Медикаменты': 9,'Коллекционные предметы': 10,
                  'Жетоны': 11, 'Ключи': 12}
    if params[:q].present?
      @tarkovitems = Tarkovitem.paginate(:page => params[:page], :per_page => 6).where('item_name_caps LIKE ?','%'+params[:q].mb_chars.upcase+'%' )
      @tarkovitems.blank? ? flash[:search] = 'По запросу '+params[:q]+' ничего не найдено.' : flash[:search] = 'Результаты  поиска по запросу '+params[:q]+' .'
    else
      if params[:item_type].present?
        @tarkovitems = Tarkovitem.paginate(:page => params[:page], :per_page => 6).where(item_type: params[:item_type]).order('created_at desc')
      else
        @tarkovitems = Tarkovitem.paginate(:page => params[:page], :per_page => 6).all
        @active ='active'
      end
    end
  end

  def tarkovitem
    i= Tarkovitem.find(params[:item_id])
    if i.nil?
      redirect_to '/tarkovmarket'
    else
      respond_to do |format|
        @iteminfo = i.item_info.html_safe
        format.js
      end
    end
  end
  def buyrequest
      m= Privatemessage.new
      i=Tarkovitem.find(params[:i])
      m.player_id = session[:player_id]
      m.message_for_id = params[:player_id]
      m.message_text ='Привет! Я заинтересован в покупке (обмене) :' + i.item_name + '. Жду ответа!'

      i.update_column(:item_message_send_by , i.item_message_send_by.append(session[:player_id]))
      m.save

      redirect_to request.referer



  end
end
