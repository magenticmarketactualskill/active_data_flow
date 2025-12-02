# frozen_string_literal: true

require 'spec_helper'

# Only run these specs if Redcord is available
if defined?(Redcord)
  require 'redis'
  require 'active_support/all'
  require_relative '../../../../app/models/active_data_flow/redcord/data_flow_run'

  RSpec.describe ActiveDataFlow::Redcord::DataFlowRun, type: :model do
    before(:all) do
      # Configure Redis for testing
      @redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/15')
      
      begin
        @redis.ping
        Redcord.configure { |c| c.redis = @redis }
        @redis_available = true
      rescue Redis::CannotConnectError
        @redis_available = false
      end
    end

    before(:each) do
      skip "Redis not available" unless @redis_available
      @redis.flushdb
    end

    describe 'model structure' do
      it 'inherits from T::Struct' do
        expect(described_class.ancestors).to include(T::Struct)
      end

      it 'includes Redcord::Base' do
        expect(described_class.ancestors.map(&:to_s)).to include('Redcord::Base')
      end

      it 'has required attributes' do
        expect(described_class.props.keys).to include(
          :data_flow_id, :status, :run_after,
          :started_at, :ended_at, :error_message,
          :first_id, :last_id,
          :created_at, :updated_at
        )
      end
    end

    describe 'CRUD operations' do
      it 'creates a new DataFlowRun' do
        run = described_class.create!(
          data_flow_id: 'flow_123',
          status: 'pending',
          run_after: Time.current.to_i + 3600
        )

        expect(run.id).not_to be_nil
        expect(run.data_flow_id).to eq('flow_123')
        expect(run.status).to eq('pending')
      end

      it 'finds a DataFlowRun by ID' do
        run = described_class.create!(
          data_flow_id: 'flow_456',
          status: 'pending',
          run_after: Time.current.to_i
        )

        found = described_class.find(run.id)
        expect(found.data_flow_id).to eq('flow_456')
      end

      it 'updates a DataFlowRun' do
        run = described_class.create!(
          data_flow_id: 'flow_789',
          status: 'pending',
          run_after: Time.current.to_i
        )

        run.status = 'in_progress'
        run.started_at = Time.current.to_i
        run.save!

        reloaded = described_class.find(run.id)
        expect(reloaded.status).to eq('in_progress')
        expect(reloaded.started_at).not_to be_nil
      end

      it 'queries by indexed status' do
        described_class.create!(data_flow_id: 'f1', status: 'pending', run_after: Time.current.to_i)
        described_class.create!(data_flow_id: 'f2', status: 'in_progress', run_after: Time.current.to_i)
        described_class.create!(data_flow_id: 'f3', status: 'pending', run_after: Time.current.to_i)

        pending_runs = described_class.where(status: 'pending').to_a
        expect(pending_runs.count).to eq(2)
      end

      it 'queries by data_flow_id' do
        described_class.create!(data_flow_id: 'flow_x', status: 'pending', run_after: Time.current.to_i)
        described_class.create!(data_flow_id: 'flow_x', status: 'success', run_after: Time.current.to_i)
        described_class.create!(data_flow_id: 'flow_y', status: 'pending', run_after: Time.current.to_i)

        flow_x_runs = described_class.where(data_flow_id: 'flow_x').to_a
        expect(flow_x_runs.count).to eq(2)
      end
    end

    describe 'type safety' do
      it 'enforces String type for data_flow_id' do
        expect {
          described_class.new(
            data_flow_id: 123,  # Wrong type
            status: 'pending',
            run_after: Time.current.to_i
          )
        }.to raise_error(TypeError)
      end

      it 'enforces Integer type for run_after' do
        expect {
          described_class.new(
            data_flow_id: 'flow_123',
            status: 'pending',
            run_after: 'not_an_integer'  # Wrong type
          )
        }.to raise_error(TypeError)
      end

      it 'allows nil for optional fields' do
        run = described_class.create!(
          data_flow_id: 'flow_minimal',
          status: 'pending',
          run_after: Time.current.to_i,
          started_at: nil,
          ended_at: nil,
          error_message: nil,
          first_id: nil,
          last_id: nil
        )

        expect(run.started_at).to be_nil
        expect(run.ended_at).to be_nil
        expect(run.error_message).to be_nil
      end
    end

    describe 'instance methods' do
      let(:pending_run) do
        described_class.create!(
          data_flow_id: 'flow_test',
          status: 'pending',
          run_after: Time.current.to_i + 3600
        )
      end

      let(:in_progress_run) do
        described_class.create!(
          data_flow_id: 'flow_test',
          status: 'in_progress',
          run_after: Time.current.to_i,
          started_at: Time.current.to_i
        )
      end

      let(:completed_run) do
        described_class.create!(
          data_flow_id: 'flow_test',
          status: 'success',
          run_after: Time.current.to_i - 3600,
          started_at: Time.current.to_i - 3600,
          ended_at: Time.current.to_i - 3000
        )
      end

      it 'checks pending? status' do
        expect(pending_run.pending?).to be true
        expect(in_progress_run.pending?).to be false
      end

      it 'checks in_progress? status' do
        expect(in_progress_run.in_progress?).to be true
        expect(pending_run.in_progress?).to be false
      end

      it 'checks success? status' do
        expect(completed_run.success?).to be true
        expect(pending_run.success?).to be false
      end

      it 'checks completed? status' do
        expect(completed_run.completed?).to be true
        expect(pending_run.completed?).to be false
        expect(in_progress_run.completed?).to be false
      end

      it 'calculates duration' do
        expect(completed_run.duration).to eq(600)
        expect(pending_run.duration).to be_nil
      end

      it 'checks if due' do
        past_run = described_class.create!(
          data_flow_id: 'flow_past',
          status: 'pending',
          run_after: Time.current.to_i - 100
        )
        
        future_run = described_class.create!(
          data_flow_id: 'flow_future',
          status: 'pending',
          run_after: Time.current.to_i + 3600
        )

        expect(past_run.due?).to be true
        expect(future_run.due?).to be false
      end

      it 'provides model_name for Rails routing' do
        expect(described_class.model_name.name).to eq('data_flow_run')
      end
    end
  end
else
  RSpec.describe 'ActiveDataFlow::Redcord::DataFlowRun' do
    it 'skips tests when Redcord is not available' do
      skip 'Redcord gem not loaded'
    end
  end
end
