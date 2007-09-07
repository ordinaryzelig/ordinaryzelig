class Notifier < ActionMailer::Base
  
  def exception(ex, user)
    recipients 'admin@ordinaryzelig.org'
    from 'rails@ordinaryzelig.org'
    subject "#{ex.class}: #{ex}"
    body :exception => ex, :user => user
  end
  
end
