class ReceivedRecordsController < ApplicationController
  before_action :set_received_record, only: [:show]

  def index
    @received_records = ReceivedRecord.includes(:data)
                                     .recent
                                     .page(params[:page])
                                     .per(20)
    
    # Filter by type if specified
    if params[:record_type].present?
      @received_records = @received_records.by_type(params[:record_type])
    end
    
    @record_types = ReceivedRecord.distinct.pluck(:record_type)
  end

  def show
  end

  private

  def set_received_record
    @received_record = ReceivedRecord.find(params[:id])
  end
end
