class CreateReportTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :report_types do |t|
      t.int :report_type_id
      t.string :report_type_name

      t.timestamps
    end
  end
end
