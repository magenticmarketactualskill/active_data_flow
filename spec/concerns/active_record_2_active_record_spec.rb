# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveDataFlow::ActiveRecord2ActiveRecord do
  let(:test_class) do
    Class.new do
      include ActiveDataFlow::ActiveRecord2ActiveRecord

      def self.name
        "TestFlow"
      end
    end
  end

  describe "class methods" do
    it "provides source method" do
      expect(test_class).to respond_to(:source)
    end

    it "provides sink method" do
      expect(test_class).to respond_to(:sink)
    end

    it "provides runtime method" do
      expect(test_class).to respond_to(:runtime)
    end

    it "provides register method" do
      expect(test_class).to respond_to(:register)
    end

    it "provides execute method" do
      expect(test_class).to respond_to(:execute)
    end
  end

  describe "class attributes" do
    it "has source_connector attribute" do
      expect(test_class).to respond_to(:source_connector)
      expect(test_class).to respond_to(:source_connector=)
    end

    it "has sink_connector attribute" do
      expect(test_class).to respond_to(:sink_connector)
      expect(test_class).to respond_to(:sink_connector=)
    end

    it "has runtime_connector attribute" do
      expect(test_class).to respond_to(:runtime_connector)
      expect(test_class).to respond_to(:runtime_connector=)
    end

    it "has data_flow_instance attribute" do
      expect(test_class).to respond_to(:data_flow_instance)
      expect(test_class).to respond_to(:data_flow_instance=)
    end
  end
end
