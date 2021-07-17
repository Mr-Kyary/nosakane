# README
# 概要
学生の就職活動（会社訪問、面接）の予定をGoogleカレンダーに書き出すシステムです。

学生は、WEBブラウザもしくはLINE上で就職活動の予定の作成・編集等ができます。

管理者（先生側）は、以下のようなことが出来ます。

- 各学生の就職活動予定の管理
- 会社一覧の追加、削除
- 投稿種別の追加、削除

# システム情報
- 開発環境
  - Ruby version<br>2.6.6
  - Ruby on Rails version<br>6.1.3.2 

# 完成した機能
- 投稿機能
  - ブラウザからの投稿機能
  - LINEからの投稿機能<br>以下のQRコードより登録してください。<br>![qrcode](https://user-images.githubusercontent.com/67830980/126037546-73bd50cb-682e-41a4-b330-7fc80938a811.jpg)
- カレンダーへの出力
  - GASにて以下のソースコードを利用してください。<br>https://script.google.com/d/1r_t0NUuiSClW4PcdLUqmvKZASeNWcTBist7AvbjMZBS9a3-QVE2j0LHg/edit?usp=sharing
- ユーザーログイン機能
- 管理者ログイン機能

# 今後の課題
- フロント周りの調整/デザインの見直し
- Googleカレンダーへの書き出しはAPIを使用
