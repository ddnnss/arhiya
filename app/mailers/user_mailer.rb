class UserMailer < ApplicationMailer
  default from: 'GAMESCUM'

  def activation(user)
    @user=user
    mail(to: @user.player_email,subject: "Регистрация на сайте GAMESCUM")
  end

  def squadapp(mail)

    mail(to: mail,subject: "Добавление в отряд")
  end

  def neworder(mail)
    mail(to: mail,subject: "Новый заказ на сайте")
  end

  def resetpassword(user)
    @user=user
    mail(to: @user.usermail,subject: "Новый пароль на сайте GAMESCUM")
  end

  def newapply

    mail(to: 'marketing@avtostar-kmv.ru',subject: "Заявка в вайтлист")
  end

  def feedback (name,email,subject,messagetxt)
    @name=name
    @email=email
    @subject=subject
    @messagetxt=messagetxt
    mail(to: 'ddnnss.i1@gmail.com',subject: "Feedback form")
  end
end
