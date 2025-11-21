# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveDataFlow::DataFlow, type: :model do
  let(:source) { ActiveDataFlow::Connector::Source::Base.new(model: "User") }
  let(:sink) { ActiveDataFlow::Connector::Sink::Base.new(model: "UserBackup") }
  let(:runtime) { ActiveDataFlow::Runtime::Base.new(interval: 60) }

  describe "validations" do
    it "validates presence of name" do
      data_flow = described_class.new(
        source: source,
        sink: sink
      )
      expect(data_flow).not_to be_valid
      expect(data_flow.errors[:name]).to include("can't be blank")
    end

    it "validates presence of source" do
      data_flow = described_class.new(
        name: "test",
        sink: sink
      )
      expect(data_flow).not_to be_valid
      expect(data_flow.errors[:source]).to include("can't be blank")
    end

    it "validates presence of sink" do
      data_flow = described_class.new(
        name: "test",
        source: source
      )
      expect(data_flow).not_to be_valid
      expect(data_flow.errors[:sink]).to include("can't be blank")
    end
  end

  describe "#source_type" do
    it "returns the class name of the source" do
      data_flow = described_class.new(source: source)
      expect(data_flow.source_type).to eq("ActiveDataFlow::Connector::Source::Base")
    end
  end

  describe "#sink_type" do
    it "returns the class name of the sink" do
      data_flow = described_class.new(sink: sink)
      expect(data_flow.sink_type).to eq("ActiveDataFlow::Connector::Sink::Base")
    end
  end

  describe "#runtime_type" do
    it "returns the class name of the runtime" do
      data_flow = described_class.new(runtime: runtime)
      expect(data_flow.runtime_type).to eq("ActiveDataFlow::Runtime::Base")
    end

    it "returns nil when runtime is not set" do
      data_flow = described_class.new
      expect(data_flow.runtime_type).to be_nil
    end
  end

  describe "serialization" do
    it "serializes and deserializes source objects" do
      data_flow = described_class.new(
        name: "test",
        source: source,
        sink: sink
      )
      
      # Simulate save/load cycle
      serialized = ActiveDataFlow::DataFlow::ObjectSerializer.dump(source)
      deserialized = ActiveDataFlow::DataFlow::ObjectSerializer.load(serialized)
      
      expect(deserialized).to be_a(ActiveDataFlow::Connector::Source::Base)
      expect(deserialized.as_json).to eq(source.as_json)
    end
  end
end
