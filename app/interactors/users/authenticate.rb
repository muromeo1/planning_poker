module Users
  class Authenticate
    include Interactor
    include BaseInteractor

    requires :email, :password

    def call
      user_authenticated? ? return_token : raise_error
    rescue StandardError => error
      context.fail!(error: error.message)
    end

    private

    def user
      @user ||= User.find_by(email: email)
    end

    def user_authenticated?
      user&.authenticate(password)
    end

    def return_token
      context.token = JsonWebToken.encode(user_id: user.id)
    end

    def raise_error
      raise 'Invalid credentials'
    end
  end
end
