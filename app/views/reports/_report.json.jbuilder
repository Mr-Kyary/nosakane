json.extract! report, :id, :report_id, :student_id, :report_type_id, :planed_date, :company_id, :report_detail, :created_at, :updated_at
json.url report_url(report, format: :json)
