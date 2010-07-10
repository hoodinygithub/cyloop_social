module Juixe
  module Acts #:nodoc:
    module Rateable #:nodoc:

      module ClassMethods

        def acts_as_rateable(options = {})
          @rating_options = {
            :class => 'Rating',
            :as    => 'rateable'
          }.merge(options)

          has_many :ratings, :as => @rating_options[:as], :dependent => :destroy, :class_name => @rating_options[:class]
          include Juixe::Acts::Rateable::InstanceMethods
          extend Juixe::Acts::Rateable::SingletonMethods
        end
      end

      # This module contains class methods
      module SingletonMethods
        # Helper method to lookup for ratings for a given object.
        # This method is equivalent to obj.ratings
        def find_ratings_for(obj)
          rateable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s

          @rating_options[:class].constantize.find(:all,
            :conditions => ["#{@rating_options[:as]}_id = ? and #{@rating_options[:as]}_type = ?", obj.id, rateable],
            :order => "created_at DESC"
          )
        end

        # Helper class method to lookup ratings for
        # the mixin rateable type written by a given user.
        # This method is NOT equivalent to Rating.find_ratings_for_user
        def find_ratings_by_user(user)
          rateable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s

          @rating_options[:class].constantize.find(:all,
            :conditions => ["user_id = ? and #{@rating_options[:as]}_type = ?", user.id, rateable],
            :order => "created_at DESC"
          )
        end

        # Helper class method to lookup rateable instances
        # with a given rating.
        def find_by_rating(rating)
          rateable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          ratings = @rating_options[:class].constantize.find(:all,
            :conditions => ["rating = ? and #{@rating_options[:as]}_type = ?", rating, rateable],
            :order => "created_at DESC"
          )
          rateables = []
          ratings.each { |r|
            rateables << r.rateable
          }
          rateables.uniq!
        end
      end

      module InstanceMethods
        def rating
          average = 0.0
          ratings.valid.each { |r|
            average = average + r.rating
          }
          if ratings.valid.size != 0
            average = average / ratings.valid.size
          end
          average
        end
      end
    end
  end
end
