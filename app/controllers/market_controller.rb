class MarketController < ApplicationController
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
end
