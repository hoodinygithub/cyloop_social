class CreateReservedSlugs < ActiveRecord::Migration
  def self.up
    create_table :reserved_slugs do |t|
      t.string :slug
      
      t.timestamps
    end
    add_index :reserved_slugs, :slug
    %w(my admin stations radio music home pages discover users user artists artist undefined x45b x46b).each do |slug|
      ReservedSlug.create(:slug => slug)
    end
  end

  def self.down
    remove_index :reserved_slugs, :slug
    drop_table :reserved_slugs
  end
end
