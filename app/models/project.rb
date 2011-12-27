class Project < ActiveRecord::Base

has_many :time_entries
belongs_to :user, :foreign_key => 'owner_id', :class_name => 'User'

end
