module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[ show update destroy ]

      # GET /users
      def index
        @users = User.all

        render json: @users
      end

      def overview
        opportunities = Opportunity.where.in(
          customer_email: Customer.where(user: @user).pluck(:email)
        ).all

        won_opportunities = opportunities.where(won: true)
        opportunities_revenue = won_opportunities.sum(:price)
        incoming_revenue = opportunities.where(won: false).sum(:price)
        sales = won_opportunities.count
        customer_count = Customer.where(user: @user).count

        other_incomes = Transaction.where(user: @user).where(type: 'Income').sum(:amount)
        expenses = Transaction.where(user: @user).where(type: 'Expense').sum(:amount)
        total_revenue = opportunities_revenue + other_incomes - expenses

        render json: {
          total_revenue:,
          incoming_revenue:,
          sales:,
          customer_count:
        }
      end 

      # GET /users/1
      def show
        render json: @user
      end

      # POST /users
      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy!
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def user_params
          params.require(:user).permit(:company_name, :email)
        end
    end
  end 
end
