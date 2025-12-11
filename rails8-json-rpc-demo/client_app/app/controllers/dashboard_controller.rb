class DashboardController < ApplicationController
  def index
    @total_users = User.count
    @total_orders = Order.count
    @pending_records = OutgoingRecord.pending.count
    @sent_records = OutgoingRecord.sent.count
    @failed_records = OutgoingRecord.failed.count
    @recent_outgoing = OutgoingRecord.recent.limit(10)
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_orders = Order.includes(:user).order(created_at: :desc).limit(5)
  end
end
