Rails.application.routes.draw do


  root 'page#index'

  match '/login'  => 'player#login', via: [:post]
  match '/registration'  => 'player#registration', via: [:post]
 #----------ADMIN------------------------
  match '/admin/forum'  => 'admin#forum_admin', via: [:get]
  match 'addforum'  => 'admin#addforum', via: [:post]
end
