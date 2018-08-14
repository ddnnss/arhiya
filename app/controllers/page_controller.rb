class PageController < ApplicationController
  before_action :checkpm

  def checkpm
    if session[:active]
      pm = Privatemessage.where(message_for_id: session[:player_id])
      pm.blank? ? session[:pm_count] = 0 : session[:pm_count] = pm.count

    end
  end
  def index
    @homepage_topics = Topic.where(topic_show_homepage: true ).order('created_at desc').last(6)
    @homepage_topics.blank? ? @noslides = true :  @noslides = false
  end

end
