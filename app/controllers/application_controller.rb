class ApplicationController < ActionController::API
  before_action :authorize

  def current_user
    @current_user ||= authorize_token.user
  end

  def render_json(hash)
    render json: hash
  end

  private

  def authorize
    authorize_token.success? ? current_user : render_json(error: authorize_token.error)
  end

  def authorize_token
    @authorize_token ||= Sessions::AuthorizeToken.call(request.headers)
  end
end
