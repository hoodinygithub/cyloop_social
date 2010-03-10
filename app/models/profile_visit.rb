# == Schema Information
#
# Table name: profile_visits
#
#  id           :integer(4)      not null, primary key
#  owner_id     :integer(4)
#  visitor_id   :integer(4)
#  site_id      :integer(4)
#  total_visits :integer(4)      default(0)
#  created_at   :datetime
#  updated_at   :datetime
#

class ProfileVisit < ActiveRecord::Base
  include Summary::TotalListensProxy

  module Most
    def most_visited_users(limit = 10)
      profile_visits.most_visited(:users, limit)
    end

    def most_visited_artists(limit = 10)
      profile_visits.most_visited(:artist, limit)
    end
  end

  after_save :update_visit_count
  belongs_to :site
  belongs_to :owner, :class_name => 'Account'
  belongs_to :visitor, :class_name => 'Account'
  
  validates_presence_of :site #, :total_listens
  named_scope :recent_visits, lambda { |count| {:select => "id, owner_id, MAX(updated_at) AS updated_at", :group => "visitor_id", :order => "updated_at DESC", :limit => count}}
  
  def update_visit_count
    unless owner.nil?
      #owner.update_attribute(:visit_count, self.total_visits)
      # owner.visit_count = ProfileVisit.sum(:total_visits, :conditions => ["owner_id = ?", owner.id])
      # owner.save!
      owner.increment!(:visit_count)
    end
  end

  def self.most_visited(collection, limit = nil)
    max_visits = nil
    sum(
      :total_visits,
      :group => 'owner',
      :limit => limit,
      :order => "sum_total_visits DESC",
      :include  => :visitor,
      :conditions => ["accounts.type = ?", collection.to_s.singularize.titleize]
    ).map do |object, total_visits|
      max_visits ||= total_visits
      TotalListensProxy.new(object, total_visits, max_visits)
    end
  end

  def self.record(owner, site, visitor)
    owner_id = owner.kind_of?(Account) ? owner.id : owner
    site_id = site.kind_of?(Site) ? site.id : site
    visitor_id = visitor.kind_of?(Account) ? visitor.id : visitor
    
    unless owner_id==visitor_id
      visit = ProfileVisit.find_or_create_by_owner_id_and_site_id_and_visitor_id(owner_id, site_id, visitor_id)
      visit.total_visits += 1
      visit.save!
    end
  end
end
