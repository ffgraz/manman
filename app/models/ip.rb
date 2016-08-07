class Ip < ActiveRecord::Base
	set_table_name "ip"
	belongs_to :node, :foreign_key => "node_id"
	belongs_to :nets, :foreign_key => 'net_id'
end
