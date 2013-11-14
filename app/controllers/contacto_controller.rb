class ContactoController < ApplicationController
  def index
  	
  end

  def contacto_email
  	@name = params[:contacto][:name]
  	@email = params[:contacto][:email]
  	@message = params[:contacto][:message]

	ContactoMailer.contacto_email(@name,@email,@message).deliver
  end
end
