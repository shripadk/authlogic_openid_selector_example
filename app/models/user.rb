class User < ActiveRecord::Base
  acts_as_authentic do |c| 
    c.validate_login_field = false
    # optional, but if a user registers by openid, he should at least share his email-address with the app
    c.validate_email_field = false
    # fetch the email either by sreg or ax
    c.required_fields = ["http://axschema.org/contact/email"]
    c.optional_fields = [:email, :nickname]
  end
  
  private
  
  def map_openid_registration(registration)
    
    if registration.empty?
      # No email returned
      self.email_autoset = false
    else
      # Email set by SREG?
      unless registration[:email].nil? && registration[:email].blank? 
        self.email = registration[:email] 
        self.email_autoset = true
      else
        # Email set by AX
        unless registration['http://axschema.org/contact/email'].nil? && registration['http://axschema.org/contact/email'].first.blank?
          self.email = registration['http://axschema.org/contact/email'].first
          self.email_autoset = true
        else
          # registration-hash seems to contain information other than sreg- or ax-email
          self.email_autoset = false
        end
      end
    end

  end
  
end