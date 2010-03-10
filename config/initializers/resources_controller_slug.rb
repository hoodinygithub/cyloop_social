module Ardes
  module ResourcesController
    module InstanceMethods
      def route_enclosing_names
        @route_enclosing_names ||= returning(Array.new) do |req|
          enclosing_segments.each do |segment|
            unless segment.is_optional or segment.is_a?(::ActionController::Routing::DividerSegment)
              req << [segment.value, true] if segment.is_a?(::ActionController::Routing::StaticSegment)
              if segment.is_a?(::ActionController::Routing::DynamicSegment)
                if req.empty? && segment.key == :slug
                  req << ['accounts', false]
                else
                  req.last[1] = false
                end
              end
            end
          end
        end
      rescue MissingSegment
        @route_enclosing_names = params.keys.select{|k| k.to_s =~ /_id$/}.map{|id| [id.sub('_id','').pluralize, false]}
      end
    end
  end
end
