# frozen_string_literal: true

module Api
    module V1
      class ApiController < ActionController::API
        def hello 
            render json: { message: "Hello World" }
        end 
      end
    end
end