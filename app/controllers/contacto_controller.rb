class ContactoController < ApplicationController
  def index
  	
  end

  def contacto_email
  	@name = params[:contacto][:name]
  	@email = params[:contacto][:email]
  	@message = params[:contacto][:message]

  	if(valid_email?(@email) && !@name.blank? && !@message.blank?)
		ContactoMailer.contacto_email(@name,@email,@message).deliver
		redirect_to contacto_success_path
	else
      flash.now[:error] = 'Asegurate de tener todos los campos correctos'
      render :index
    end
  end

  def email_success
  	
  end

  private
  
  def valid_email?(email)
    email.present? && (email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end
end
