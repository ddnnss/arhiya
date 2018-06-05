class MarketController < ApplicationController
  def newtarkovitem
    i = Tarkovitem.new
    p = Player.find(session[:player_id])
    i.player_id = session[:player_id]
    i.item_name = params[:item_name]
    i.item_name_caps = params[:item_name].mb_chars.upcase
    i.item_name_translit = Translit.convert(params[:item_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
    i.item_tags = params[:item_name].gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',').mb_chars.upcase
    i.item_type = params[:item_tag][:item_tag_id]
    i.item_to_sell_count = params[:item_to_sell_count].to_i
    i.item_price_virt_rub = params[:item_price_virt_rub].to_i
    i.item_price_real_rub = params[:item_price_real_rub].to_i
    i.item_price_virt_usd = params[:item_price_virt_usd].to_i
    i.item_price_virt_eur = params[:item_price_virt_eur].to_i
    p.update_column(:player_sells_count, p.player_sells_count + 1)
    if params[:item_barter_checkbox] == 'on'
      i.item_barter_for = params[:item_barter]
      i.item_barter = true
    end
    if session[:admin] || session[:vip]
      i.item_vip = true
    end
    i.save
    redirect_to '/profile/' + p.player_nickname_translit
  end
end
