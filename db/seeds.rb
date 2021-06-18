# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

##################### 管理者 Admin
Admin.create!(
  name: 'admin',
  email: 'admin@test.com',
  password: 'password'
)
##################### 管理者 Admin ここまで

##################### ユーザー User
Student.create!(
  student_id: 202001,
  name: 'てすと太郎',
  line_account_id: 'lineaccountid1234'
)
##################### ユーザー User ここまで
