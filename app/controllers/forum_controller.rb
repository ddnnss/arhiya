class ForumController < ApplicationController
  before_action :get_cart, :check_activity, :set_activity

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

  def checkpm
    if session[:active]
      pm = Privatemessage.where(player_id: session[:player_id])
      pm.blank? ? session[:pm_count] = 0 : session[:pm_count] = pm.count

    end
  end

  def index
    @title = 'ФОРУМ'
    @activeforum = 'active'
    @forums=Forum.all
    t=Topic.all
    t.empty? ? @empty=true : @empty=false
  end
  def showsubforum

    @activeforum = 'active'
    @subforum = Subforum.find_by_subforum_name_translit(params[:subforum_name])
    @title = @subforum.subforum_name
    @topic =  @subforum.topics.paginate(:page => params[:page], :per_page => 6).where.not(topic_pinned: true).order('updated_at desc')
    @pinnedtopic = @subforum.topics.where(topic_pinned: true).order('updated_at desc')

    @pinnedtopic.nil? ? @pinned = false : @pinned = true


    @icons = ['ion-help','ion-alert','ion-android-bulb','ion-ios-star','ion-beer','ion-android-chat','ion-alert-circled','ion-android-settings','ion-bonfire','ion-cash','ion-chatboxes','ion-coffee','ion-social-freebsd-devil','ion-speakerphone','ion-happy','ion-heart','ion-heart-broken','ion-help']

  end
  def showtopic
    @activeforum = 'active'
    @topic = Topic.find_by(topic_name_translit: params[:topic_name])
    @title = @topic.topic_name
    @topic.update_column(:topic_views, @topic.topic_views + 1)
    @posts = @topic.posts.paginate(:page => params[:page], :per_page => 6)
  end
  def addtopic
 if logged_in?
      t = Topic.new
      t.player_id=session[:player_id]
      t.subforum_id = params[:subforum_id]
      t.topic_name = params[:addtopic][:topic_name]
      t.topic_name_caps = params[:addtopic][:topic_name].mb_chars.upcase

      t.topic_name_translit = Translit.convert(params[:addtopic][:topic_name].gsub(' ','-').gsub('ь','').gsub('ъ','').gsub(/[?!*.,:;\/`"']/, ''), :english)
      temp = Topic.find_by_topic_name_translit(t.topic_name_translit)
      unless temp.blank?
        t.topic_name_translit = Translit.convert(params[:addtopic][:topic_name].gsub(' ','-').gsub('ь','').gsub('ъ','').gsub(/[?!*.,:;\/`"']/, ''), :english) + '-' + [*('0'..'9')].shuffle[0,3].join
      end
      t.topic_icon = params[:topic_icon]
      if params.permit(:showhome).to_h[:showhome] == 'show'
        t.topic_show_homepage = true
        uploadedFile = params[:addtopic][:home_topic_image]
        File.open(Rails.root.join('public','images','homepage',uploadedFile.original_filename), 'wb' ) do |f|
          f.write(uploadedFile.read)

        end
        t.topic_home_image = uploadedFile.original_filename
        t.topic_home_type = params.permit(:topic_type).to_h[:topic_type]
        t.topic_home_icon = params.permit(:home_topic_icon).to_h[:home_topic_icon]

      end
      if params[:pintopic] == 'pin'
        t.topic_pinned = true
      end
      t.save

      p = Post.new
      p.player_id=session[:player_id]
      p.topic_id=t.id
      p.post_text = params[:content]
      p.save

      redirect_to '/forum/' + t.subforum.subforum_name_translit
 else
   redirect_to '/'
   end



  end
  def addpost
    if params[:new_post_content]== ''
      flash[:error] = 'А сообщение кто писать будет?'
      redirect_to '/topic/' + params[:topic_name] +'#forum-reply'
    else
      p = Post.new
      p.player_id = session[:player_id]
      p.topic_id = params[:topic_id]
      p.post_text = params[:new_post_content]
      p.save
      redirect_to '/topic/' + params[:topic_name] +'#post'+p.id.to_s
    end


  end
  def editpost1
      post = Post.find(params[:post_id])
      post.update_column(:post_text ,params[:post_content])
      redirect_to '/topic/' + params[:topic_name]+'#post'+post.id.to_s
  end
  def editpost
    post = Post.find(params[:post_id])
    respond_to do |format|
      @post_id = post.id
      @topic_id = post.topic_id
      @topic_name = post.topic.topic_name_translit
      @post_text = post.post_text.html_safe
      format.js
    end
  end
  def deletepost
    p = Post.find(params[:post_id])
    tmp = p.topic.topic_name_translit
    p.destroy!
    redirect_to '/topic/' + tmp
  end
  def deletetopic
    t = Topic.find(params[:topic_id])
    tmp = t.subforum.subforum_name_translit
    t.destroy!
    redirect_to '/forum/' + tmp
  end
  def closetopic
    t = Topic.find(params[:topic_id])
    if t.topic_closed
      t.update_column(:topic_closed,false)

    else
      t.update_column(:topic_closed,true)
    end

    redirect_to '/forum/' + t.subforum.subforum_name_translit
  end
  def pintopic
    t = Topic.find(params[:topic_id])
    if t.topic_pinned
      t.update_column(:topic_pinned,false)
    else
      t.update_column(:topic_pinned,true)
    end


    redirect_to '/forum/' + t.subforum.subforum_name_translit
  end
end
