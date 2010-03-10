class AddDomainToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :domain, :string
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'www.cyloop.com' WHERE id = 1"
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'prodigy.msn.cyloop.com' WHERE id = 10"
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'br.msn.cyloop.com' WHERE id = 11"
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'latam.msn.cyloop.com' WHERE id = 12"
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'latino.msn.cyloop.com' WHERE id = 13"
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'ca.fr.msn.cyloop.com' WHERE id = 14"
    ActiveRecord::Base.connection.execute "UPDATE sites SET domain = 'ca.en.msn.cyloop.com' WHERE id = 15"
  end

  def self.down
    remove_column :sites, :domain
  end
end
