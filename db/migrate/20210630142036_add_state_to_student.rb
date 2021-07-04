class AddStateToStudent < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :state, :integer
  end
end
