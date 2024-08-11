module Api
  module V1
    class OpportunitiesController < ApiController
      before_action :set_opportunity, only: %i[ show update destroy add_note delete_note update_note ]
      before_action :set_customer_opportunities, only: %i[ index ]

      # GET /opportunities
      def index
        render json: @opportunities
      end

      # GET /opportunities/1
      def show
        render json: @opportunity
      end

      # POST /opportunities
      def create
        @opportunity = Opportunity.new(opportunity_params)

        if @opportunity.save
          render json: @opportunity, status: :created
        else
          render json: @opportunity.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /opportunities/1
      def update
        won_stages = %w[completed done]
        
        if won_stages.include?(opportunity_params[:stage]) && !@opportunity.won
          extra_params = { won: true, won_date: Date.today }
        end
        
        if @opportunity.update(opportunity_params.merge(extra_params || {}))
          render json: @opportunity
        else
          render json: @opportunity.errors, status: :unprocessable_entity
        end
      end

      # DELETE /opportunities/1
      def destroy
        @opportunity.destroy!
      end

      def add_note
        @opportunity.notes.create!(content: params[:content])
        render json: @opportunity
      end

      def update_note
        @opportunity.notes.find(params[:note_id]).update!(content: params[:content])
        render json: @opportunity
      end

      def delete_note
        @opportunity.notes.find(params[:note_id]).destroy!
        render json: @opportunity
      end

      private

        def set_customer_opportunities 
          @opportunities = Opportunity.where.in(
            customer_email: Customer.where(user: @user).pluck(:email)
          ).all
        end 

        # Use callbacks to share common setup or constraints between actions.
        def set_opportunity
          @opportunity = Opportunity.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def opportunity_params
          params.require(:opportunity).permit(:price, :customer_id, :notes, :stage, :won, :customer_email, :title, :date, :paid, :archived)
        end
    end
  end 
end