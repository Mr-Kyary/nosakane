class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :reports_id
      t.string :student_id
      t.integer :report_type_id
      t.date :planned_date
      t.integer :company_id

      t.timestamps
    end
  end
end
