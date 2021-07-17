class AddReportIdInProgressToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :report_id_in_progress, :integer
  end
end
