class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admin do |t|
    end
  end

  def self.down
    drop_table :admin
  end
end
