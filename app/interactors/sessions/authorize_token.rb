module Sessions
  class AuthorizeToken
    include Interactor
    include BaseInteractor

    requires :Authorization
    validate :token

    def call
      check_user_existence
    rescue StandardError => error
      context.fail!(error: error.message)
    end

    private

    def token
      @token ||= context.Authorization
    end

    def user_id
      @user_id ||= JsonWebToken.decode(token).try(:[], :user_id)
    end

    def user
      @user ||= User.find_by(id: user_id)
    end

    def check_user_existence
      user.present? ? return_user : return_error
    end

    def return_user
      context.user = user
    end

    def return_error
      raise 'Invalid token'
    end
  end
end
