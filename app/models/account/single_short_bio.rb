module Account::SingleShortBio
  
  def self.included(base)
    base.class_eval do
      def short_bio=(body)
        unless body.blank?
          if bio.nil?
            create_bio :short => body
          else
            bio.short = body
          end
        else
          self.bio = nil
        end
      end

      def short_bio
        bio.try(:short)
      end
    end
  end

end
