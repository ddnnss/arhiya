Rails.application.routes.draw do


  root 'page#index'
  match '/videos' => 'page#videos', via: [:get]

  match '/faq' => 'page#faq', via: [:get]
  match '/wiki' => 'page#wiki', via: [:get]
  match '/events' => 'page#events', via: [:get]
  match '/squads' => 'page#squads', via: [:get]
  match '/event(/:event_id)' => 'page#event', via: [:get]
  match '/event_app(/:event_id)' => 'page#eventapp', via: [:get]
  match '/launcher' => 'page#launcher', via: [:get]
  match '/blackmarket' => 'market#index', via: [:get]

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
  match '/addnewevent'  => 'admin#addnewevent', via: [:post]
  match '/addnewcontract'  => 'admin#addnewcontract', via: [:post]
  match '/admin/events'  => 'admin#events', via: [:get]
  match '/admin/event'  => 'admin#event', via: [:get]
  match '/admin/deleteevent'  => 'admin#deleteevent', via: [:get]
  match '/admin/players'  => 'admin#players', via: [:get]
  match '/admin/squads'  => 'admin#squads', via: [:get]
  match '/admin/squad'  => 'admin#squad', via: [:get]
  match '/updatesquad'  => 'admin#updatesquad', via: [:post]
  match '/admin/contracts'  => 'admin#contracts', via: [:get]
  match '/admin'  => 'admin#index', via: [:get]
  match '/admin/eventinfo'  => 'admin#eventinfo', via: [:get]
  match '/admin/userinfo'  => 'admin#userinfo', via: [:get]
  match '/adminuser'  => 'admin#adminuser', via: [:post]
  match '/addmaincat'  => 'admin#addmaincat', via: [:post]
  match '/addscumitem'  => 'admin#addscumitem', via: [:post]
  match '/editmaincat'  => 'admin#editmaincat', via: [:get]
  match '/itemdel'  => 'admin#itemdel', via: [:get]
  match '/itemedit'  => 'admin#itemedit', via: [:get]
  match '/admin/shop'  => 'admin#shop', via: [:get]
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
  match '/squaddeny(/:squad_id/:player_id)'  => 'squad#squaddeny', via: [:get]
  match '/squaddel(/:squad_id)'  => 'squad#squaddel', via: [:get]
  match '/squadedit(/:squad_id)'  => 'squad#squadedit', via: [:get]
  match '/squadleave'  => 'squad#squadleave', via: [:get]
  match '/event_app(/:event_id/:player_id)'  => 'squad#squadadd', via: [:get]
  match '/squadkick(/:squad_id/:player_id)'  => 'squad#squadkick', via: [:get]
  match '/squadapply(/:squad_id)'  => 'squad#squadapply', via: [:get]

  #----------shop------------------------

  match '/cat(/:cat_name_translit)'  => 'market#showcat', via: [:get]
  match '/tocart(/:item_id)'  => 'market#addtocart', via: [:get]
  match '/remcart(/:item_id)'  => 'market#removecart', via: [:get]

end
