class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
	before_create :create_activation_digest
	# before_save {self.email = email.downcase}
	# attr_accessor :remember_token

	validates :name, 	presence: true, length: { maximum: 50 }

	validates :email, 	presence: true, length: { maximum: 255 },
						format: { with: VALID_EMAIL_REGEX },
						uniqueness: {case_sensitive: false}

	has_secure_password
	validates :password, length: { minimum: 6 }, allow_blank: true

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
	# Запоминает пользователя в базе данных для использования в постоянных сеансах.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Возвращает true, если указанный токен соответствует дайджесту.
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Забывает пользователя
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Активирует учетную запись.
	def activate
		update_attribute(:activated,
		true)
		update_attribute(:activated_at, Time.zone.now)
	end

	# Посылает письмо со ссылкой на страницу активации.
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

private

	# Преобразует адрес электронной почты в нижний регистр.
	def downcase_email
		self.email = email.downcase
	end

	# Создает и присваивает токен активации и его дайджест.
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end
