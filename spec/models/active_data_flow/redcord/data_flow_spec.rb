# frozen_string_literal: true

require 'spec_helper'

# Only run these specs if Redcord is available
if defined?(Redcord)
  require 'redis'
  require 'active_support/all'
  require_relative '../../../../app/models/active_data_flow/redcord/data_flow'

  RSpec.describe ActiveDataFlow::Redcord::DataFlow, type: :model do
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
          :name, :source, :sink, :runtime, :status,
          :next_source_id, :last_run_at, :last_error,
          :created_at, :updated_at
        )
      end
    end

    describe 'CRUD operations' do
      it 'creates a new DataFlow' do
        flow = described_class.create!(
          name: 'test_flow',
          source: '{"class_name":"TestSource"}',
          sink: '{"class_name":"TestSink"}',
          status: 'active'
        )

        expect(flow.id).not_to be_nil
        expect(flow.name).to eq('test_flow')
        expect(flow.status).to eq('active')
      end

      it 'finds a DataFlow by ID' do
        flow = described_class.create!(
          name: 'findable_flow',
          source: '{}',
          sink: '{}',
          status: 'active'
        )

        found = described_class.find(flow.id)
        expect(found.name).to eq('findable_flow')
      end

      it 'finds a DataFlow by indexed attribute' do
        described_class.create!(
          name: 'indexed_flow',
          source: '{}',
          sink: '{}',
          status: 'active'
        )

        found = described_class.find_by(name: 'indexed_flow')
        expect(found).not_to be_nil
        expect(found.name).to eq('indexed_flow')
      end

      it 'updates a DataFlow' do
        flow = described_class.create!(
          name: 'updatable_flow',
          source: '{}',
          sink: '{}',
          status: 'active'
        )

        flow.status = 'inactive'
        flow.save!

        reloaded = described_class.find(flow.id)
        expect(reloaded.status).to eq('inactive')
      end

      it 'queries by indexed status' do
        described_class.create!(name: 'flow1', source: '{}', sink: '{}', status: 'active')
        described_class.create!(name: 'flow2', source: '{}', sink: '{}', status: 'inactive')
        described_class.create!(name: 'flow3', source: '{}', sink: '{}', status: 'active')

        active_flows = described_class.where(status: 'active').to_a
        expect(active_flows.count).to eq(2)
      end
    end

    describe 'type safety' do
      it 'enforces String type for name' do
        expect {
          described_class.new(
            name: 123,  # Wrong type
            source: '{}',
            sink: '{}',
            status: 'active'
          )
        }.to raise_error(TypeError)
      end

      it 'allows nil for optional fields' do
        flow = described_class.create!(
          name: 'minimal_flow',
          source: '{}',
          sink: '{}',
          status: 'active',
          runtime: nil,
          next_source_id: nil,
          last_run_at: nil,
          last_error: nil
        )

        expect(flow.runtime).to be_nil
        expect(flow.next_source_id).to be_nil
      end
    end

    describe 'custom methods' do
      let(:flow) do
        described_class.create!(
          name: 'test_flow',
          source: '{"class_name":"TestSource"}',
          sink: '{"class_name":"TestSink"}',
          runtime: '{"interval":3600,"enabled":true}',
          status: 'active'
        )
      end

      it 'provides model_name for Rails routing' do
        expect(described_class.model_name.name).to eq('data_flow')
      end

      it 'parses JSON attributes' do
        expect(flow.send(:parsed_source)).to eq({'class_name' => 'TestSource'})
        expect(flow.send(:parsed_sink)).to eq({'class_name' => 'TestSink'})
        expect(flow.send(:parsed_runtime)).to eq({'interval' => 3600, 'enabled' => true})
      end

      it 'calculates interval_seconds' do
        expect(flow.interval_seconds).to eq(3600)
      end

      it 'checks if enabled' do
        expect(flow.enabled?).to be true
      end
    end
  end
else
  RSpec.describe 'ActiveDataFlow::Redcord::DataFlow' do
    it 'skips tests when Redcord is not available' do
      skip 'Redcord gem not loaded'
    end
  end
end
