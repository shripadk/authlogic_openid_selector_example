class User < ActiveRecord::Base
  is_gravtastic :email, :filetype => :png, :default => "identicon", :size => 120
  
  validates_uniqueness_of :name, :message => "should be unique!"
  
  def before_save
    if self.name.nil? || self.name.blank?
      self.name = "user#{Time.now.to_i}"
    end
  end 
  
  
  
  acts_as_authentic do |c| 
    c.validate_login_field = false
    # optional, but if a user registers by openid, he should at least share his email-address with the app
    c.validate_email_field = false
    # fetch email by ax
    c.openid_required_fields = [:email,"http://axschema.org/contact/email"]
    #c.openid_required_fields = [:language, "http://axschema.org/pref/language"]
  end
 
  
  private
  
  def map_openid_registration(registration)
    # email by sreg
      unless registration["email"].nil? && registration["email"].blank? 
              self.email_autoset = true
              self.email = registration["email"] 
      end
      
      # email by ax
      unless registration['http://axschema.org/contact/email'].nil? && registration['http://axschema.org/contact/email'].first.blank?
              self.email_autoset = true
              self.email = registration['http://axschema.org/contact/email'].first
          # else
          #    # registration-hash seems to contain information other than the email-address
          #            self.email_autoset = false
      end
  end
  
end