class AddBackgroundImageToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :background_file_name, :string
    add_column :accounts, :background_content_type, :string
    add_column :accounts, :background_file_size, :integer
    add_column :accounts, :background_updated_at, :datetime
    add_column :accounts, :background_align, :string
    add_column :accounts, :background_repeat, :string
    add_column :accounts, :background_fixed, :boolean
  end

  def self.down
    remove_column :accounts, :background_repeat
    remove_column :accounts, :background_align
    remove_column :accounts, :background_updated_at
    remove_column :accounts, :background_file_size
    remove_column :accounts, :background_content_type
    remove_column :accounts, :background_file_name
    remove_column :accounts, :background_fixed
  end
end
