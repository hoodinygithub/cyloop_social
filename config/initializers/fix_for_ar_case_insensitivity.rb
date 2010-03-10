module ActiveRecord
  module ConnectionAdapters
    class Column
      #by default active record ignores case-sensitivity settings for both varchar (string) and text columns. 
      #we want case-sensitivity disabled for varchar (string) columns 
      def text?
        type == :text
      end
    end
  end
end