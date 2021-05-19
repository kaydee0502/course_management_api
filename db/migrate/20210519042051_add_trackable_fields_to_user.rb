class AddTrackableFieldsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.change  :sign_in_count, :integer , default: 0, null: false
      t.change  :current_sign_in_at, :datetime
      t.change :last_sign_in_at, :datetime
      t.string     :current_sign_in_ip
      t.string     :last_sign_in_ip
    end
  end
end
