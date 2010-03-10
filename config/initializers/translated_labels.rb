module ActionView::Helpers::FormHelper
  def label(object_name, method, text = nil, options = {})
    text ||= t(:"#{object_name}.#{method}", :default => :"basics.#{method}")
    ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_label_tag(text, options)
  end
end

class ActionView::Helpers::FormBuilder
  def submit(value = :save, options = {})
    @template.button_tag(value, options.reverse_merge(:id => "#{object_name}_submit"))
  end
end
