class List < ActiveRecord::Migration

  def self.up        
    create_table :lists do |t|
      t.string :title
      t.integer :position
      t.boolean :completed
      t.timestamps
    end  
  end 
         
  def self.down
    drop_table :lists
  end
  
end