json.extract! report, :id, :user_id, :report_type_id, :planned_at, :report_detail, :created_at, :updated_at
json.url report_url(report, format: :json)
