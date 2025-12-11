class DashboardController < ApplicationController
  def index
    @total_received = ReceivedRecord.count
    @recent_records = ReceivedRecord.recent.limit(10)
    @records_by_type = ReceivedRecord.group(:record_type).count
    @processed_count = ReceivedRecord.processed.count
    @unprocessed_count = ReceivedRecord.unprocessed.count
  end
end
