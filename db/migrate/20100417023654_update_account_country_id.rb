class UpdateAccountCountryId < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-EOF
    UPDATE accounts a
    INNER JOIN cities c ON a.city_id = c.id
    INNER JOIN regions r ON c.region_id = r.id
    INNER JOIN countries ct on r.country_id = ct.id
    SET a.country_id = ct.id
    WHERE a.country_id IS NULL
    EOF
  end

  def self.down
  end
end
