class PageController < ApplicationController



  def index
    @title = 'ГЛАВНАЯ'
    @homepage_topics = Topic.where(topic_show_homepage: true ).order('created_at desc').last(6)
    @homepage_topics.blank? ? @noslides = true :  @noslides = false
  end

  def videos
    @title = 'ИГРОВОЕ ВИДЕО'
    @activevideo = 'active'
@videos = ['2F8xGIMomHM','rXoSmlB-JJc','UZGI_4qGiu0','xSqiIEDP09Y','K19lXMOeG2I','laJT-AeZjjk','-kka0NVEGcs','XKQsc249IiI']
  end

end
