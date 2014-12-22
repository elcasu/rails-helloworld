class User < ActiveRecord::Base
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
end