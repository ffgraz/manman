require "digest/md5"

class Person < ActiveRecord::Base
  set_table_name "person"
  belongs_to :admin
  has_many :location

  attr_protected :password

  validates_presence_of :email, :password, :firstname, :lastname, :admin
  validates_uniqueness_of  :email

  validates_format_of :email,
      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i ,
      :on => :create


  # operator overloading for updating passwords
  def password=(str)
    write_attribute(:password, Digest::MD5.hexdigest(str))
  end


  def self.authenticate(user_name, password)
    return Person.find( :first, :conditions =>
                      ["email = BINARY ? AND password = BINARY ?",
                      user_name,
                      Digest::MD5.hexdigest(password)] )
  end

  def self.revoke_pass(email)
    password = newpass( 8 )
    person = Person.find( :first,
                          :conditions => [ "email = ?", email] )
    #

  end

private
  # generate alphanumeric password
  def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end
