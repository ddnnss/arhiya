class UserMailer < ApplicationMailer
  default from: 'GAMESCUM'

  def activation(user)
    @user=user
    mail(to: @user.player_email,subject: "Регистрация на сайте GAMESCUM")
  end

  def resetpassword(user)
    @user=user
    mail(to: @user.usermail,subject: "Новый пароль на сайте GAMESCUM")
  end

  def newuser

    mail(to: 'ddnnss.i1@gmail.com',subject: "New user registered")
  end

  def feedback (name,email,subject,messagetxt)
    @name=name
    @email=email
    @subject=subject
    @messagetxt=messagetxt
    mail(to: 'ddnnss.i1@gmail.com',subject: "Feedback form")
  end
end
