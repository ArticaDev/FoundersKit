module Api
  module V1
    class CustomersController < ApiController
      before_action :set_customer, only: %i[ show update destroy ]

      # GET /customers
      def index
        @customers = Customer.where(user: @user).all

        render json: @customers
      end

      # GET /customers/1
      def show
        render json: @customer
      end

      # POST /customers
      def create
        @customer = Customer.new(
          customer_params.merge(user: @user)
        )

        if @customer.save
          render json: @customer, status: :created
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /customers/1
      def update
        if @customer.update(customer_params)
          render json: @customer
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      # DELETE /customers/1
      def destroy
        @customer.opportunities.destroy_all
        @customer.destroy!
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_customer
          @customer = Customer.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def customer_params
          params.require(:customer).permit(:name, :phone, :email)
        end
    end
  end
end 
