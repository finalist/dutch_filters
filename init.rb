# Include hook code here
ActiveRecord::Base.send(:include, DutchFilters::ActiveRecord::Base::InstanceMethods)
ActiveRecord::Base.send(:extend, DutchFilters::ActiveRecord::Base::ClassMethods)
