class AdminController < ApplicationController
  def forum_admin
    @forum = Forum.all
    @icons = ['ion-help','ion-alert','ion-android-bulb','ion-ios-star','ion-beer','ion-android-chat','ion-alert-circled','ion-android-settings','ion-bonfire','ion-cash','ion-chatboxes','ion-coffee','ion-social-freebsd-devil','ion-speakerphone','ion-happy','ion-heart','ion-heart-broken','ion-help']
  end
  def addtopic
    @icons = ['ion-help','ion-alert','ion-android-bulb','ion-ios-star','ion-beer','ion-android-chat','ion-alert-circled','ion-android-settings','ion-bonfire','ion-cash','ion-chatboxes','ion-coffee','ion-social-freebsd-devil','ion-speakerphone','ion-happy','ion-heart','ion-heart-broken','ion-help']
    @subforum_id = params[:subforum_id]
    @topic_type = ['Первый взгляд','Обновление','Премьера','Патч','Гайд','Новости','Событие','Интересная тема']
  end

  def whitelist
    @wh=Whitelist.all

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
  def whadd
    w = Whitelist.find_by_player_id(params[:steam_id])
    w.update_column(:added,true)
    UserMailer.whapply(w.player_email).deliver_later
    redirect_to admin_whitelist_path

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
