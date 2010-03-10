ActionView::Base.field_error_proc = lambda do |html_tag, instance|
 %<<span class="fieldWithErrors">#{html_tag}</span>>
end

#module ActionView 
#  module Helpers 
#    module ActiveRecordHelper
#      def error_messages_for(*object_names)
#        messages = []
#        object_names.each do |object_name|
#          object = instance_variable_get("@#{object_name}")
#          if object && !object.errors.empty?      
#            object.errors.full_messages.each do |message| 
#              messages << %(<li>"#{message}"</li>) unless message =~ /is invalid/
#            end
#          end
#        end
#        if messages.size > 0
#          content_tag(:div, 
#          #content_tag(:h2, s("some_of_the_fields_are_invalid_title")) +
#          content_tag(:ul, messages), :id => 'errorExplanation')
#        end
#      end
#    end
#  end
#end
