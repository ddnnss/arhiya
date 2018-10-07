Rails.application.routes.draw do


  root 'page#index'
  match '/videos' => 'page#videos', via: [:get]

  match '/faq' => 'page#faq', via: [:get]
  match '/wiki' => 'page#wiki', via: [:get]
  match '/events' => 'page#events', via: [:get]
  match '/squads' => 'page#squads', via: [:get]
  match '/event(/:event_id)' => 'page#event', via: [:get]
  match '/launcher' => 'page#launcher', via: [:get]

  #----------PLAYER------------------------
  match '/login'  => 'player#login', via: [:post]
  match '/registration'  => 'player#registration', via: [:post]
  match '/logout' => 'player#destroy', via: [:get]
  match '/profile(/:player_nickname)' => 'player#playerprofile', via: [:get]
  match '/addcomment'  => 'player#addcomment', via: [:post]
  match '/editplayer'  => 'player#editplayer', via: [:post]
  match '/sendpm'  => 'player#sendpm', via: [:post]
  match '/deletepm(/:pm_id)'  => 'player#deletepm', via: [:get]
  match '/activate(/:player_id)' => 'player#activate', via: [:get]
 #----------ADMIN------------------------
  match '/admin/forum'  => 'admin#forum_admin', via: [:get]
  match '/admin/addtopic'  => 'admin#addtopic', via: [:get]
  match '/addevent'  => 'admin#addevent', via: [:post]
  match '/admin/events'  => 'admin#events', via: [:get]
  match '/admin/players'  => 'admin#players', via: [:get]
  match '/admin'  => 'admin#index', via: [:get]
  match '/admin/eventinfo'  => 'admin#eventinfo', via: [:get]

  match '/addfaq'  => 'admin#addfaq', via: [:post]
  match '/admin/faq'  => 'admin#faq', via: [:get]
  match '/addforum'  => 'admin#addforum', via: [:post, :get]

  #----------FORUM------------------------
  match '/forums'  => 'forum#index', via: [ :get]
  match '/forum(/:subforum_name)' => 'forum#showsubforum', via: [ :get]
  match '/topic(/:topic_name)' => 'forum#showtopic', via: [ :get]
  match '/addtopic'  => 'forum#addtopic', via: [:post]
  match '/addpost'  => 'forum#addpost', via: [:post]
  match '/editpost(/:post_id)'  => 'forum#editpost', via: [:get]
  match '/editpost1'  => 'forum#editpost1', via: [:post]
  match '/deletepost(/:post_id)'  => 'forum#deletepost', via: [:get]
  match '/deletetopic(/:topic_id)'  => 'forum#deletetopic', via: [:get]
  match '/closetopic(/:topic_id)'  => 'forum#closetopic', via: [:get]
  match '/pintopic(/:topic_id)'  => 'forum#pintopic', via: [:get]

  #----------SQUAD------------------------
  match '/newsquad'  => 'squad#newsquad', via: [:post]
  match '/squadadd(/:squad_id/:player_id)'  => 'squad#squadadd', via: [:get]

  match '/event_app(/:event_id/:player_id)'  => 'squad#squadadd', via: [:get]






end
