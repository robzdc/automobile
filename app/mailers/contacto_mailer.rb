class ContactoMailer < ActionMailer::Base
  default from: "from@example.com"

  def contacto_email(name, email, message)
  	@name = name
  	@email = email
  	@message = message

    mail(to: "from@example.com", subject: "#{@name} te contacto")
  end
end
