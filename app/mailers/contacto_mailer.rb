class ContactoMailer < ActionMailer::Base
  default from: "robz.del.castillo@gmail.com"

  def contacto_email(name, email, message)
  	@name = name
  	@email = email
  	@message = message

    mail(to: "robz.del.castillo@gmail.com", subject: "#{@name} te contacto")
  end
end
