Rails.application.routes.draw do


  root 'page#index'
  #----------PLAYER------------------------
  match '/login'  => 'player#login', via: [:post]
  match '/registration'  => 'player#registration', via: [:post]
  match '/logout' => 'player#destroy', via: [:get]
  match '/profile(/:player_nickname)' => 'player#playerprofile', via: [:get]
  match '/addcomment'  => 'player#addcomment', via: [:post]
  match '/editplayer'  => 'player#editplayer', via: [:post]
 #----------ADMIN------------------------
  match '/admin/forum'  => 'admin#forum_admin', via: [:get]
  match '/admin/addtopic'  => 'admin#addtopic', via: [:get]
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
end
