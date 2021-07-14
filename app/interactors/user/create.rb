class User
  class Create
    include Interactor
    include BaseInteractor

    requires :name,
             :email,
             :password,
             :password_confirmation

    def call
      user_exists?
      create_user
      authenticate_user
    rescue => e
      context.fail!(error: e.message)
    end

    private

    def user_email
      @user_email ||= I18n.transliterate(email.downcase)
    end

    def user
      @user ||= User.find_by(email: user_email)
    end

    def user_exists?
      raise 'Email already registered' if user.present?
    end

    def create_user
      context.user = User.create(context.to_h.merge({ email: user_email }))
    end

    def authenticate_user
      context.token = User::Authenticate.call(user: user_email, password: password)
    end
  end
end
