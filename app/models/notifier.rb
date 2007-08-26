class Notifier < ActionMailer::Base
  
  def registration_notification(user)
    recipients user.email
    from "flying_monkey@ordinaryzelig.org"
    subject "thank you for registering with ordinary zelig"
  end
  
  def exception(ex, user)
    recipients 'admin@ordinaryzelig.org'
    from 'rails@ordinaryzelig.org'
    subject "#{ex.class}: #{ex}"
    body :exception => ex, :user => user
  end
  
end
