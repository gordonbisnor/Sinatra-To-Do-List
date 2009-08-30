class ListItem < ActiveRecord::Migration

  def self.up        
    create_table :list_items do |t|
      t.string :title
      t.integer :list_id
      t.integer :position
      t.boolean :completed
      t.timestamps
    end  
  end 
         
  def self.down
    drop_table :list_items
  end
  
end