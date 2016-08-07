class Admin < ActiveRecord::Base
  set_table_name "admin"
  has_many :person

end
