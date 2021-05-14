class AddDescToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :description, :text
  end
end
