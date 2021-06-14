class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :report_id
      t.integer :student_id
      t.integer :report_type_id
      t.datetime :planed_date
      t.integer :company_id
      t.text :report_detail

      t.timestamps
    end
  end
end
