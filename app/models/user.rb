class User < ApplicationRecord

  has_many :attendances, dependent: :destroy
  #Attendanceモデルに対して1対多の関連性,
  #Userモデルデータが削除されると、関連するAttendanceモデルのデータもまとめて削除される
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 } # 存在性、文字数の検証
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # メールアドレスの正規表現
  validates :email, presence: true, length: { maximum: 100 }, # 存 在性、文字数の検証
                    format: { with: VALID_EMAIL_REGEX}, # メールアドレスの有効性
                    uniqueness: true # 一意性
  validates :department, length: { in: 1..50 }, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  
  has_secure_password # ハッシュ化しデータベースに保存
                      #has_secure_passwordがオブジェクト生成時に存在性を検証
  
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
 
  # 3文字以上かつ50文字以下,nil以外に空文字""にも対応




end
