require "mysql"

class Node < ActiveRecord::Base
	set_table_name "node"
	belongs_to :location
	belongs_to :person
	has_many :ip

	validates_presence_of :name, :location_id
	validates_uniqueness_of :name, :scope => 'location_id'

  validates_format_of :name,
                  :with => /^([0-9a-z]*)$/,
                  :on =>  :create
  validates_format_of :name,
                  :with => /^([0-9a-z]*)$/,
                  :on =>  :save


  def comment
    # nl2br
    read_attribute(:comment).gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />")
  end

  def self.create_node(params)
    Node.create(params)
  end
end
