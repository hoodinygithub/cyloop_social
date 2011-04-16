module Account::Encryption
  def self.included(base)
    base.class_eval do
      # These attributes break references to user.email, user.name, etc. by making them refer to encrypted_email and encrypted_name by default.
      #attr_encrypted :email, :key => '1710d78515ea0f308ed10f5edc0888ee2b893d4def678849b073b703cc678ac4', :encryptor => MySQLEncryptor, :encode => false
      #attr_encrypted :name, :key => '1710d78515ea0f308ed10f5edc0888ee2b893d4def678849b073b703cc678ac4', :encryptor => MySQLEncryptor, :encode => false
      #attr_encrypted :born_on_string, :key =>'1710d78515ea0f308ed10f5edc0888ee2b893d4def678849b073b703cc678ac4', :encryptor => MySQLEncryptor, :encode => false
      #attr_encrypted :gender, :key => '1710d78515ea0f308ed10f5edc0888ee2b893d4def678849b073b703cc678ac4', :encryptor => MySQLEncryptor, :encode => false
      def self.encrypt_email(p_email)
        MySQLEncryptor.encrypt({:value => p_email, :key => '1710d78515ea0f308ed10f5edc0888ee2b893d4def678849b073b703cc678ac4'});
      end
    end
  end

  class MySQLEncryptor
    def self.encrypt(options)
      if options[:value]
        query = "SELECT hex(aes_encrypt('#{options[:value]}', '#{options[:key]}')) AS result"
        ActiveRecord::Base.connection.select_all(query).first['result']
      end
    end
    def self.decrypt(options)
      if options[:value]
        query = "SELECT aes_decrypt(unhex('#{options[:value]}'), '#{options[:key]}') AS result"
        ActiveRecord::Base.connection.select_all(query).first['result']
      end
    end
  end
end
