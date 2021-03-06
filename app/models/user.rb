class User < ActiveRecord::Base
    attr_accessor :remember_token
    # Validations
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    validates :name,  presence: true, length: { maximum: 50 }
    validates :email,
        presence: true,
        length: { maximum: 255 },
        format: { with: VALID_EMAIL_REGEX },
        uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 6 }

    # Callbacks
    before_save do
        self.email.downcase!
    end

    # Authentication built-in features
    has_secure_password

    # Returns the hash digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Generate a random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Remembers users in the database
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Forgets a user
    def forget
        update_attribute(:remember_digest, nil)
    end
end
