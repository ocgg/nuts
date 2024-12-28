class Note < ActiveRecord::Base
  self.table_name = 'notes'
  self.primary_key = 'id'
end
