class User < ActiveRecord::Base
  acts_as_authentic do |c| 
    c.validate_login_field = false
    # optional, but if a user registers by openid, he should at least share his email-address with the app
    c.validate_email_field = false
    # fetch email by ax
    c.openid_required_fields = [:email,"http://axschema.org/contact/email"]
    #c.openid_required_fields = [:language, "http://axschema.org/pref/language"]
    #c.required_fields = ["http://axschema.org/contact/email"]
    # fetch email by sreg
    #c.optional_fields = ["email"]
  end
  
  private
  
  def map_openid_registration(registration)
    
    if registration.empty?
      # no email returned
      self.email_autoset = false
    else
      # email by sreg
      unless registration["email"].nil? && registration["email"].blank? 
        self.email = registration["email"] 
        self.email_autoset = true
      else
        # email by ax
        unless registration['http://axschema.org/contact/email'].nil? && registration['http://axschema.org/contact/email'].first.blank?
          self.email = registration['http://axschema.org/contact/email'].first
          self.email_autoset = true
        else
          # registration-hash seems to contain information other than the email-address
          self.email_autoset = false
        end
      end
    end

  end
  
end