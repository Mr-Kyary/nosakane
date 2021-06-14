class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.integer :student_id
      t.string :name
      t.string :line_account_id

      t.timestamps
    end
  end
end
