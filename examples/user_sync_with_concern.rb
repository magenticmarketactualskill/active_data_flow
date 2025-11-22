# frozen_string_literal: true

# Example data flow using the ActiveRecord2ActiveRecord concern
# This would be placed in app/data_flows/user_sync_flow.rb

class UserSyncFlow
  include ActiveDataFlow::ActiveRecord2ActiveRecord

  # Define source - where data comes from
  source User.where(active: true).order(:created_at), batch_size: 100

  # Define sink - where data goes
  sink UserBackup, batch_size: 100

  # Define runtime (optional)
  runtime ActiveDataFlow::Runtime::Base.new(interval: 3600)

  # Register the data flow
  register name: "user_sync"
end

# Alternative usage without the concern:
class ManualUserSyncFlow
  def self.register
    source = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(
      scope: User.where(active: true).order(:created_at),
      batch_size: 100
    )

    sink = ActiveDataFlow::Connector::Sink::ActiveRecordSink.new(
      model_class: UserBackup,
      batch_size: 100
    )

    runtime = ActiveDataFlow::Runtime::Base.new(interval: 3600)

    ActiveDataFlow::DataFlow.find_or_create(
      name: "manual_user_sync",
      source: source,
      sink: sink,
      runtime: runtime
    )
  end
end

# Both approaches work - the concern provides a DSL for cleaner syntax
if defined?(Rails)
  # UserSyncFlow is auto-registered via the concern
  ManualUserSyncFlow.register
end
