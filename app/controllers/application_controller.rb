class ApplicationController < ActionController::API
  before_action :authenticate

  def current_user
    @current_user ||= authorize_token.user
  end

  def render_json(hash)
    render json: hash
  end

  private

  def authenticate
    authorize_token.success? ? current_user : render_json(error: authorize_token.error)
  end

  def authorize_token
    @authorize_token ||= Sessions::AuthorizeToken.call(request.headers)
  end
end
