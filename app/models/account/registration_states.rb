module Account::RegistrationStates
  def self.included(base)
    base.class_eval do
      include AASM

      aasm_column :status

      aasm_state :just_created
      aasm_state :pending      
      aasm_state :registered
      aasm_state :deleted, :enter => :mark_as_removed
      
      aasm_event :finish_registration do
        transitions :to => :registered, :from => [:just_created, :pending]
      end
      
      aasm_event :cancel_account do
        transitions :to => :deleted, :from => [:pending, :just_created, :registered]
      end
      
      after_create do |user|
        user.update_attribute(:status, 'registered')
      end
      
      def mark_as_removed
        self.update_attribute(:deleted_at, Time.now)
        self.delete_slugs
        true
      end      
    end
  end
end