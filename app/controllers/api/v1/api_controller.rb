# frozen_string_literal: true

module Api
    module V1
      class ApiController < ActionController::API
        before_action :authenticate

        private

        def authenticate
          user_email = request.headers['Authorization']
          @user = User.find_by(email: user_email)
        end
      end
    end
end