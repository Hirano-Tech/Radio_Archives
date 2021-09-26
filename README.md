## 🖥　① 技術仕様（ローカル環境）

- **Ruby** Version 3.0.2
- **Ruby on Rails** Version 6.1.4.1
- **MySQL** Version 8.0.26
- **Docker** Version 20.10.8

## 🌏　② 技術仕様（本番環境）

- **Elastic Compute Cloud**
  - Region：アジア・パシフィック（ムンバイ）
  - インスタンスタイプ：t4g.nano

- **Relational Database Service**
  - Region：米国西部（オレゴン）
  - インスタンスタイプ：db.t2.micro

- **Simple Storage Service**
- **Cloud Front**
- **Virtual Private Cloud**

<img src='https://user-images.githubusercontent.com/63486456/134806674-eae890de-a3fb-4d35-a1db-fd9819ae964b.png' width='50%' />

## 🗝　③ ユーザー管理（認証）機能

```Ruby
# 入力されたメールアドレスから、アカウント部分とドメイン部分を切り分ける。
  /@/ =~ '入力されたメールアドレス'
  return {account: $`, domain: $'}
    # 連想配列で、値を返す。

# データベース （MySQL） で、メールアカウント， パスワードを暗号化する。
  User.connection.select_all("SELECT HEX(AES_ENCRYPT('メールアカウント， パスワード', '暗号鍵')");

# 暗号化されているものを復号化する際は以下の処理をする。
  User.connection.select_all("SELECT convert( AES_DECRYPT( UNHEX('メールアカウント， パスワード'), '復号鍵') USING '文字コード')")
```

##### 以下の URL から体験することができます。

- [ユーザー管理（認証）機能 体験ページ](http://3.109.115.169/user/registrations/new)  
※ Cookie（有効期限：5分）で、一時保存していますが、データベースには保存されません。  
※ Cookie を削除する際は、再度 新規登録フォームのページに戻っていただくか、ご自身で削除してください。
