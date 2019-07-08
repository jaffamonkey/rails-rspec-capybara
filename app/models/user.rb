class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 8}, allow_nil: true

    after_initialize :ensure_session_token

    attr_reader :password
    
    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)

        return user if user && user.is_password?(password)
        return nil
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def reset_session_token!
        previous_token = self.session_token
        
        # generate a new token and make sure it's different from previous token
        while self.session_token == previous_token
            self.session_token = generate_unique_session_token
        end

        self.save!

        return self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    private

    def generate_unique_session_token
        token = SecureRandom.urlsafe_base64(16)

        # generate a new token if this one is already taken
        while self.class.exists?(session_token: token)
            token = SecureRandom.urlsafe_base64(16)
        end

        return token
    end
end
