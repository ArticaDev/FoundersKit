module Api
  module V1
    class TransactionsController < ApiController
      before_action :set_transaction, only: %i[ show update destroy ]

      # GET /transactions
      def index
        @transactions = Transaction.where(user: @user).all

        render json: @transactions
      end

      # GET /transactions/1
      def show
        render json: @transaction
      end

      def summary 
        transactions = Transaction.where(user: @user)
        opportunities = Opportunity.where.in(
          customer_email: Customer.where(user: @user).pluck(:email)
        ).where(won: true).all

        opportunity_transactions = opportunities.map do |opportunity|
          OpenStruct.new({ name: opportunity.title, type: 'Income', amount: opportunity.price, date: opportunity.won_date })
        end

        all_transactions = transactions + opportunity_transactions

        time_unit = params[:time_unit]
        number_of_units = params[:number_of_units].to_i
        
        summary_data = all_transactions.each_with_object(
            Hash.new { |h, k| h[k] = { income: 0, expense: 0, profit: 0, total_balance: 0 } }
          ) do |transaction, map|    

          key = transaction.date.strftime(time_unit == 'month' ? '%Y-%m' : '%Y-%m-%d')
          map[key][transaction.type.downcase.to_sym] += transaction.amount
          map[key][:profit] = map[key][:income] - map[key][:expense]

          total_income = map.sum { |_, v| v[:income] }
          total_expense = map.sum { |_, v| v[:expense] }
          map[key][:total_balance] = total_income - total_expense
        end
        
        summary_data = summary_data.sort.last(number_of_units).to_h

        render json: summary_data
      end

      # POST /transactions
      def create
        @transaction = Transaction.new(transaction_params.merge(user: @user))
        if @transaction.save
          render json: @transaction, status: :created, location: @transaction
        else
          render json: @transaction.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /transactions/1
      def update
        if @transaction.update(transaction_params)
          render json: @transaction
        else
          render json: @transaction.errors, status: :unprocessable_entity
        end
      end

      # DELETE /transactions/1
      def destroy
        @transaction.destroy!
      end

      private
        def set_transaction
          @transaction = Transaction.find(params[:id])
        end

        def transaction_params
          params.require(:transaction).permit(
            :name, :type, :amount, :date, :recurrency
          )
        end
    end
  end
end 