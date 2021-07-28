module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate, only: %i[create login]

      def create
        result = Users::Create.call(user_params)

        if result.success?
          render_json(token: result.token)
        else
          render_json(error: result.error)
        end
      end

      def login
        result = Users::Authenticate.call(user_params)

        if result.success?
          render_json(token: result.token)
        else
          render_json(error: result.error)
        end
      end

      private

      def user_params
        params.permit(
          :name,
          :email,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
