class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	before_save {self.email = email.downcase}
	attr_accessor :remember_token

	validates :name, 	presence: true, length: { maximum: 50 }

	validates :email, 	presence: true, length: { maximum: 255 }, 
						format: { with: VALID_EMAIL_REGEX },
						uniqueness: {case_sensitive: false}

	has_secure_password

	validates :password, length: { minimum: 6 }

	# Возвращает дайджест для указанной строки.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ?
		BCrypt::Engine::MIN_COST :
		BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Возвращает случайный токен.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = ...
		update_attribute(:remember_digest, ...)
	end
end
