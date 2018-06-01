class AdminController < ApplicationController
  def forum_admin
    @forum = Forum.all
    @icons = ['ion-help','ion-alert','ion-android-bulb','ion-ios-star','ion-beer','ion-android-chat']


  end
  def addforum
    if params[:addmain] = 'add'
      f = Forum.new
      f.forum_name = params[:addforum][:forum_name]

    end
    if params[:addsub] = 'add'

    end
    if params[:addmain] = 'edit'

    end
    if params[:addsub] = 'edit'

    end

  end
end
