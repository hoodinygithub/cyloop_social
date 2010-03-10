class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :email
      t.string   :name
      t.string   :crypted_password, :limit => 40
      t.string   :salt,             :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :gender
      t.date     :born_on
    end
  end

  def self.down
    drop_table :users
  end
end
