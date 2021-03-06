# # 管理者
# Admin.create!(
#   name: 'admin',
#   email: 'admin@test.com',
#   password: 'password'
# )

########################利用種別
type_name = ['面接', '筆記試験', '説明会', '就活イベント', 'インターンシップ']
5.times do
  ReportType.create!(
    report_type_name: type_name.pop
  )
end
########################利用種別 ここまで

# ########################生徒
require 'json'
hash = JSON.parse(
  '[{
    "student_id": 211001,
    "name": "有田梨紗"
  }, {
    "student_id": 211002,
    "name": "石田美翔"
  }, {
    "student_id": 211003,
    "name": "糸原真生"
  }, {
    "student_id": 211004,
    "name": "岩田祥子"
  }, {
    "student_id": 211005,
    "name": "大崎マミ"
  }, {
    "student_id": 211006,
    "name": "奥井千夏"
  }, {
    "student_id": 211007,
    "name": "高見紗耶月"
  }, {
    "student_id": 211008,
    "name": "田部友美"
  }, {
    "student_id": 211009,
    "name": "西本萌菜"
  }, {
    "student_id": 211010,
    "name": "野津成美"
  }, {
    "student_id": 212002,
    "name": "上田広一郎"
  }, {
    "student_id": 212003,
    "name": "大野貴也"
  }, {
    "student_id": 212004,
    "name": "梶谷和"
  }, {
    "student_id": 212005,
    "name": "長岡拓海"
  }, {
    "student_id": 212006,
    "name": "奈良井大資"
  }, {
    "student_id": 212007,
    "name": "長谷川結理"
  }, {
    "student_id": 212008,
    "name": "米原霧斗"
  }, {
    "student_id": 212009,
    "name": "米山瑞起"
  }, {
    "student_id": 212010,
    "name": "嵐谷勇也"
  }, {
    "student_id": 212011,
    "name": "石倉雅大"
  }, {
    "student_id": 212012,
    "name": "井上寛登"
  }, {
    "student_id": 212013,
    "name": "上村一貴"
  }, {
    "student_id": 212014,
    "name": "江田大葵"
  }, {
    "student_id": 212015,
    "name": "太田梨沙"
  }, {
    "student_id": 212016,
    "name": "奥田達也"
  }, {
    "student_id": 212017,
    "name": "小畑匠"
  }, {
    "student_id": 212018,
    "name": "影山龍斗"
  }, {
    "student_id": 212019,
    "name": "加納楓冬"
  }, {
    "student_id": 212020,
    "name": "河井雅途"
  }, {
    "student_id": 212021,
    "name": "黒目浩太"
  }, {
    "student_id": 212022,
    "name": "木幡駿哉"
  }, {
    "student_id": 212023,
    "name": "佐藤康太"
  }, {
    "student_id": 212024,
    "name": "白枝貢多"
  }, {
    "student_id": 212025,
    "name": "澄川達也"
  }, {
    "student_id": 212026,
    "name": "瀧川利奈"
  }, {
    "student_id": 212027,
    "name": "田中大暉"
  }, {
    "student_id": 212028,
    "name": "中尾友哉"
  }, {
    "student_id": 212029,
    "name": "永瀬靖幸"
  }, {
    "student_id": 212030,
    "name": "中田直斗"
  }, {
    "student_id": 212031,
    "name": "藤原早希"
  }, {
    "student_id": 212032,
    "name": "升田裕稀"
  }, {
    "student_id": 212033,
    "name": "松岡美都"
  }, {
    "student_id": 212034,
    "name": "宮廻翔"
  }, {
    "student_id": 212035,
    "name": ""
  }, {
    "student_id": 212036,
    "name": "八壁菜々子"
  }, {
    "student_id": 212037,
    "name": "渡邉充"
  }, {
    "student_id": 214001,
    "name": "熱田信子"
  }, {
    "student_id": 214002,
    "name": "上田愛結"
  }, {
    "student_id": 214003,
    "name": "川下莉宝"
  }, {
    "student_id": 214004,
    "name": "北脇日菜子"
  }, {
    "student_id": 214005,
    "name": "佐藤良紀"
  }, {
    "student_id": 214006,
    "name": "佐中美咲"
  }, {
    "student_id": 214007,
    "name": "原千里"
  }, {
    "student_id": 214008,
    "name": "松浦歩夢"
  }, {
    "student_id": 201001,
    "name": "岡鈴菜"
  }, {
    "student_id": 201002,
    "name": "幸田春菜"
  }, {
    "student_id": 201003,
    "name": "原ののか"
  }, {
    "student_id": 201004,
    "name": "細木栞"
  }, {
    "student_id": 201005,
    "name": "松本佳奈"
  }, {
    "student_id": 202001,
    "name": "浅田夕稀乃"
  }, {
    "student_id": 202002,
    "name": "阿食龍二"
  }, {
    "student_id": 202003,
    "name": "安達悠也"
  }, {
    "student_id": 202004,
    "name": "糸原竜之介"
  }, {
    "student_id": 202005,
    "name": "影山久朗"
  }, {
    "student_id": 202006,
    "name": "小原珠々華"
  }, {
    "student_id": 202007,
    "name": "品川洸人"
  }, {
    "student_id": 202008,
    "name": "深田遥大"
  }, {
    "student_id": 202009,
    "name": "福島悠斗"
  }, {
    "student_id": 202010,
    "name": "福田留美"
  }, {
    "student_id": 202011,
    "name": "堀内航"
  }, {
    "student_id": 202012,
    "name": "村上楓佳"
  }, {
    "student_id": 202013,
    "name": "飯塚宥介"
  }, {
    "student_id": 202014,
    "name": "板倉啓太"
  }, {
    "student_id": 202015,
    "name": "大森千慧"
  }, {
    "student_id": 202016,
    "name": "落合徹"
  }, {
    "student_id": 202017,
    "name": "狩野啓太"
  }, {
    "student_id": 202018,
    "name": "杉本美香"
  }, {
    "student_id": 202019,
    "name": "須田一輝"
  }, {
    "student_id": 202020,
    "name": "須田健太"
  }, {
    "student_id": 182022,
    "name": "高尾拓海"
  }, {
    "student_id": 202021,
    "name": "長島唯斗"
  }, {
    "student_id": 202022,
    "name": "永吉弘季"
  }, {
    "student_id": 202023,
    "name": "錦織清美"
  }, {
    "student_id": 202024,
    "name": "野々村和樹"
  }, {
    "student_id": 202025,
    "name": "服部勇人"
  }, {
    "student_id": 202026,
    "name": "原英寿"
  }, {
    "student_id": 202027,
    "name": "槙原隼斗"
  }, {
    "student_id": 202028,
    "name": "三島航心"
  }, {
    "student_id": 202029,
    "name": "三谷香世"
  }, {
    "student_id": 204001,
    "name": "吾郷楽斗"
  }, {
    "student_id": 204002,
    "name": "有福亜希"
  }, {
    "student_id": 204003,
    "name": "飯塚可奈子"
  }, {
    "student_id": 204004,
    "name": "石橋杏奈"
  }, {
    "student_id": 204005,
    "name": "井上璃南"
  }, {
    "student_id": 204006,
    "name": "猪原音々"
  }, {
    "student_id": 204007,
    "name": "川上純子"
  }, {
    "student_id": 204008,
    "name": "佐藤稚夏"
  }, {
    "student_id": 204009,
    "name": "柳楽澪"
  }, {
    "student_id": 204010,
    "name": "西村菜月美"
  }, {
    "student_id": 204011,
    "name": "西村萌香"
  }, {
    "student_id": 204012,
    "name": "古川望久"
  }]', symbolize_names: true)
hash.each do |h|
  Student.create!(student_id: h[:student_id].to_i, name: h[:name].to_s)
end
# ########################生徒 ここまで