class User < ApplicationRecord
  validates :fname, :lname, :address,:pcode,:email, presence: true
  #crypt_keeper :password, :encryptor => :aes_new, :key => '8898U77', salt: 'UUllI'
end
