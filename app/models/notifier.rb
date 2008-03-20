class Notifier < ActionMailer::Base
  
  def exception(ex, user, request)
    recipients 'theoz@ordinaryzelig.org'
    from 'rails@ordinaryzelig.org'
    subject "#{ex.class}: #{ex}"
    body :exception => ex, :user => user, :uri => request.request_uri, :method => request.method
  end
  
  def warning(msg)
    recipients 'theoz@ordinaryzelig'
    from 'rails@ordinaryzelig'
    subject 'warning'
    body :message => msg
  end
  
end
