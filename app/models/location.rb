class Location < ActiveRecord::Base
  set_table_name "location"
  belongs_to :person
  belongs_to :town
  belongs_to :nets
  has_many :node

  validates_presence_of :name, :person_id
  validates_uniqueness_of :name

  validates_format_of :name,
    :with => /^([0-9a-z]*)$/,
    :on =>  :create
  validates_format_of :name,
    :with => /^([0-9a-z]*)$/,
    :on =>  :save

  # validates_presence_of :archived

  @@x_zero = 4080
  @@lon_zero = 15.43844103813
  @@dx_dlon = 50675.5176
  @@y_zero = 4806
  @@lat_zero = 47.07177327969
  @@dy_dlat = 75505.521

  def lon
    @@lon_zero + (self.pixel_x.to_f - @@x_zero) / @@dx_dlon
  end

  def lat
    @@lat_zero + (@@y_zero - self.pixel_y.to_f) / @@dy_dlat
  end

  def comment
    # nl2br
    read_attribute(:comment).gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />")
  end

end
