json.extract! report, :id, :reports_id, :student_id, :report_type_id, :planned_date, :company_id, :created_at, :updated_at
json.url report_url(report, format: :json)
