class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.integer :report_type_id
      t.datetime :planned_at
      t.text :report_detail

      t.timestamps
    end
  end
end
