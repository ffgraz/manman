class PasswordMailer < ActionMailer::Base

  def password(person, password, sent_at = Time.now)
    @subject    = 'New Password'
    @body       = { :person => person, :password => password }
    @recipients = person.email
    @from       = 'noreply@graz.funkfeuer.at'
    @sent_on    = sent_at
    @headers    = {}
  end

end
