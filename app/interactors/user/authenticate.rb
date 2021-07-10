class User
  class Authenticate
    include Interactor
    include BaseInteractor

    requires :email, :password

    def call
      user_authenticated?
      return_token
    rescue StandardError => e
      context.fail!(error: e.message)
    end

    private

    def user
      @user ||= User.find_by(email: email)
    end

    def user_authenticated?
      raise 'Invalid credentials' unless user&.authenticate(password)
    end

    def return_token
      context.token = JsonWebToken.encode(user_id: user.id)
    end
  end
end
