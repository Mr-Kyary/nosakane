# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者
Admin.create!(
  name: 'admin',
  email: 'admin@test.com',
  password: 'password'
)

########################利用者
Student.create!(
  student_id: 191919,
  name: 'てすと太郎',
  line_account_id: 'lineaccountid'
)
########################利用者 ここまで

########################利用種別
type_name = ['面接', '筆記試験', '説明会', '就活イベント', 'インターンシップ']
5.times do
  ReportType.create!(
    report_type_name: type_name.pop
  )
end
########################利用種別 ここまで
