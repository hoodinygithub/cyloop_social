class ChangeLocaleIdInBios < ActiveRecord::Migration
  def self.up
    remove_column :bios, :locale_id
    add_column :bios, :locale, :string
  end

  def self.down
    remove_column :bios, :locale
    add_column :bios, :locale_id, :integer
  end
end
