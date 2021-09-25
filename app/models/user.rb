class User < ApplicationRecord
  self.table_name = 'users'

  def signed_in?
    return User.readonly.find(id)
  end

  def self.get_email_account(email_address)
    /@/ =~ email_address
    return {account: $`, domain: $'}
  end

  def self.encrypt_email(email)
    secret_key = Rails.application.credentials.User[:Secret_Key]
    return User.connection.select_all("SELECT HEX(AES_ENCRYPT('#{email}', '#{secret_key}'));").rows[0][0]
  end

  def self.encrypt_password(password)
    secret_key = Rails.application.credentials.User[:Secret_Key]
    return User.connection.select_all("SELECT HEX(AES_ENCRYPT('#{password}', '#{secret_key}'));").rows[0][0]
  end

  def self.decrypt_email(email)
    secret_key = Rails.application.credentials.User[:Secret_Key]
    return User.connection.select_all("SELECT convert( AES_DECRYPT( UNHEX('#{email}'), '#{secret_key}') USING 'utf8mb4')").rows[0][0]
  end

  def self.decrypt_password(password)
    secret_key = Rails.application.credentials.User[:Secret_Key]
    return User.connection.select_all("SELECT convert( AES_DECRYPT( UNHEX('#{password}'), '#{secret_key}') USING 'utf8mb4')").rows[0][0]
  end

  def user_sign_in
    return User.readonly.find_by(encrypt_email: encrypt_email, encrypt_password: encrypt_password)
  end
end
