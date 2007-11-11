class Notifier < ActionMailer::Base
  
  def exception(ex, user, uri)
    recipients 'theoz@ordinaryzelig.org'
    from 'rails@ordinaryzelig.org'
    subject "#{ex.class}: #{ex}"
    body :exception => ex, :user => user, :uri => uri
  end
  
  def warning(msg)
    recipients 'theoz@ordinaryzelig'
    from 'rails@ordinaryzelig'
    subject 'warning'
    body :message => msg
  end
  
end
