class Nets < ActiveRecord::Base
	set_table_name "net"
	belongs_to :location
	belongs_to :nettype
	has_many :ip

	validates_presence_of :netip, :netmask 
	#validates_uniqueness_of :netip
	
end
