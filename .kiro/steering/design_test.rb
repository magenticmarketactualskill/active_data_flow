# frozen_string_literal: true

# Test Design Template
#
# This file provides a template for designing RSpec tests for ActiveDataflow components.
# See: .kiro/steering/test_driven_design.md for testing guidelines

# Example: Base class test structure
RSpec.describe ActiveDataflow::Connector::Source do
  describe '#each' do
    context 'when not implemented by subclass' do
      it 'raises NotImplementedError' do
        source = described_class.new({})
        expect { source.each { |_record| } }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#initialize' do
    it 'accepts a configuration hash' do
      config = { key: 'value' }
      source = described_class.new(config)
      expect(source).to be_a(described_class)
    end
  end
end

# Example: Concrete implementation test structure
RSpec.describe ActiveDataflow::Connector::Source::ActiveRecord do
  let(:model_class) { double('Model', all: records) }
  let(:records) { [double('Record1'), double('Record2')] }
  let(:config) { { model: 'TestModel' } }

  before do
    stub_const('TestModel', model_class)
  end

  describe '#each' do
    it 'yields each record from the model' do
      source = described_class.new(config)
      yielded = []
      source.each { |record| yielded << record }
      expect(yielded).to eq(records)
    end

    context 'when model is not found' do
      let(:config) { { model: 'NonExistentModel' } }

      it 'raises an error' do
        expect { described_class.new(config) }.to raise_error(NameError)
      end
    end
  end

  describe '#initialize' do
    it 'validates required configuration' do
      expect { described_class.new({}) }.to raise_error(ArgumentError, /model/)
    end
  end
end

# Example: Runtime test structure
RSpec.describe ActiveDataflow::Runtime::Heartbeat::Runner do
  let(:data_flow) { double('DataFlow', run: true) }
  let(:config) { { data_flow: data_flow } }

  describe '#execute' do
    it 'runs the configured DataFlow' do
      runner = described_class.new(config)
      expect(data_flow).to receive(:run)
      runner.execute
    end

    context 'when DataFlow raises an error' do
      before do
        allow(data_flow).to receive(:run).and_raise(StandardError, 'Test error')
      end

      it 'logs the error and re-raises' do
        runner = described_class.new(config)
        expect { runner.execute }.to raise_error(StandardError, 'Test error')
      end
    end
  end
end

# Test Design Guidelines:
#
# 1. Test public interfaces, not private methods
# 2. Use descriptive context blocks for different scenarios
# 3. Mock external dependencies (databases, APIs, file systems)
# 4. Test error handling and edge cases
# 5. Keep tests focused on one behavior per example
# 6. Use let for test data, before for setup
# 7. Follow RSpec best practices (see .kiro/steering/test_driven_design.md)