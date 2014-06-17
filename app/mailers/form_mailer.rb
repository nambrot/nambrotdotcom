class FormMailer < ActionMailer::Base
  default to: "nambrot@googlemail.com"

  def hire_email(data)
    @message = data[:message]
    mail(subject: "Hire Email, Budget: #{data[:budget]}", from: "#{data[:name]} <#{data[:email]}>")
  end

  def fire_email(data)
    @message = data[:message]
    mail(subject: "Fire Email", from: "#{data[:name]} <#{data[:email]}>")
  end
end
