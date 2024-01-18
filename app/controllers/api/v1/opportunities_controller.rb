module Api
  module V1
    class OpportunitiesController < ApplicationController
      before_action :set_opportunity, only: %i[ show update destroy add_note delete_note update_note ]

      # GET /opportunities
      def index
        @opportunities = Opportunity.all

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
        if @opportunity.update(opportunity_params)
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
        # Use callbacks to share common setup or constraints between actions.
        def set_opportunity
          @opportunity = Opportunity.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def opportunity_params
          params.require(:opportunity).permit(:price, :customer_id, :notes, :stage, :won, :customer_email)
        end
    end
  end 
end