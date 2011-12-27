class Project < ActiveRecord::Base

has_many :time_entries
belongs_to :user

end
