require 'digest/sha1'

module Account::Authentication
  def self.included(base)
    base.class_eval do
      extend ClassMethods

      validates_presence_of     :email
      validates_format_of       :email, :with => /^\S+@\S+\.\w{2,}$/, :allow_blank => true
      validates_uniqueness_of   :email, :scope => :deleted_at, :case_sensitive => false
      validates_length_of       :email, :maximum => 100, :allow_blank => true

      validates_presence_of     :password,                   :if => :password_required?
      validates_length_of       :password, :within => 4..40, :if => :password_required?, :allow_blank => true
      validates_confirmation_of :password,                   :if => :password_required?      
      
      validate :validate_terms_and_privacy
      validate :check_negative_captcha
      validate :verify_current_password, :if => :current_password_required?

      before_save :encrypt_password  
      after_save :password_no_longer_dirty
      before_create :generate_confirmation_code
      attr_protected :crypted_password, :salt, :remember_token, :remember_token_expires_at
    end
  end

  # Virtual attribute for the unencrypted password
  attr_accessor :password, :current_password, :negative_captcha, :terms_and_privacy

  def reset_password_to(password)
    self.password = password
    save(false)
  end

  def action_reset=(boolean)
    @resetting_password = boolean
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def confirmed?
    confirmation_code.blank?
  end
  
  def regenerate_confirmation_code
    self.confirmation_code ? generate_confirmation_code : false
  end
  
  def password=(password)
    if password.size >0
      @password_changed = true
      @password = password
    end
  end

  def create_reset_code
    @reset = true
    self.attributes = {:reset_code => Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)}
    save(false)
  end
  
  def reset_password
    new_pass = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)[0..10]
    self.attributes = {:password => new_pass, :password_confirmation => new_pass}
    save(false)
    new_pass
  end

  def recently_reset?
    @reset
  end

  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end

  protected

  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    (crypted_password.blank? || !password.blank? || !current_password.blank?) && msn_live_id.nil?
  end

  def password_changed?
    @password_changed
  end

  def resetting_password?
    @resetting_password
  end

  def password_no_longer_dirty
    @password_changed = false
    return true
  end

  def current_password_required?
    !new_record? && password_changed? && !resetting_password?
  end

  def check_negative_captcha
    unless @negative_captcha.blank?
      errors.add(:negative_captcha, :must_be_blank)
    end
  end

  def verify_current_password
    unless crypted_password == encrypt(current_password)
      if current_password.blank?
        errors.add(:current_password, :blank)
      else
        errors.add(:current_password, :incorrect)
      end
    end
  end
  
  def validate_terms_and_privacy
    if self.is_a?(User) && just_created?
      if terms_and_privacy.nil? || terms_and_privacy.to_i == 0      
        self.errors.add(:terms_and_privacy, I18n.t("registration.terms_and_privacy_must_be_accepted"))
      end
    end
  end
  
  def generate_confirmation_code
    self.confirmation_code = Digest::SHA1.hexdigest("#{DateTime.now}--#{self.email}--#{rand(100000)}")[0, 20]
  end

  module ClassMethods
    
    def authenticate(email, password, site)
      network_ids = site.networks.collect(&:id)
      u = find_by_email_and_deleted_at_and_network_id(email, nil, network_ids) # need to get the salt and make sure the account isn't deleted
      u && u.authenticated?(password) ? u : nil
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    def confirm(code)
      if user = User.find_by_confirmation_code(code)
        user.update_attribute(:confirmation_code, nil)
        user
      end
    end
    
  end
end
