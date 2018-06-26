class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	
		if user && user.authenticate(params[:session][:password])
		# Осуществить вход пользователя и переадресовать на страницу профиля.
		else
		# Создать сообщение об ошибке.
		render 'new'
  end

  def destroy
  	
  end
end
