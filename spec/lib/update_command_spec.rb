# frozen_string_literal: true

require 'spec_helper'
require 'rainbow'

# Add vendor paths to load path for testing since they are not standard gems yet
$LOAD_PATH.unshift File.expand_path('../../../vendor/submoduler_common/lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../../vendor/submoduler_child/lib', __FILE__)

require 'submoduler_child/update_command'

RSpec.describe SubmodulerChild::UpdateCommand do
  let(:args) { [] }
  subject { described_class.new(args) }

  before do
    # Suppress stdout/stderr
    allow($stdout).to receive(:puts)
    allow($stderr).to receive(:puts)
    
    # Mock system calls by default to avoid actual execution
    allow(subject).to receive(:system).and_return(true)
    allow(subject).to receive(:`).and_return("")
    
    # Mock internal helpers
    allow(subject).to receive(:run_tests).and_return(true)
    allow(subject).to receive(:git_clean?).and_return(true)
    allow(subject).to receive(:bump_version)
    allow(subject).to receive(:push_changes)
    allow(subject).to receive(:create_github_release)
  end

  describe '#execute' do
    context 'when tests pass' do
      before do
        allow(subject).to receive(:run_tests).and_return(true)
      end

      it 'runs tests' do
        expect(subject).to receive(:run_tests)
        subject.execute
      end

      context 'when git is clean' do
        before do
          allow(subject).to receive(:git_clean?).and_return(true)
        end

        it 'does not stage or commit changes' do
          expect(subject).not_to receive(:stage_changes)
          expect(subject).not_to receive(:commit_changes)
          subject.execute
        end

        it 'bumps version and pushes' do
          expect(subject).to receive(:bump_version)
          expect(subject).to receive(:push_changes)
          subject.execute
        end
      end

      context 'when git is dirty' do
        before do
          allow(subject).to receive(:git_clean?).and_return(false)
        end

        it 'stages and commits changes' do
          expect(subject).to receive(:stage_changes)
          expect(subject).to receive(:commit_changes)
          subject.execute
        end
      end

      context 'with --release flag' do
        let(:args) { ['--release'] }

        it 'attempts to create a GitHub release' do
          expect(subject).to receive(:create_github_release)
          subject.execute
        end
      end

      context 'without --release flag' do
        let(:args) { [] }

        it 'does not create a GitHub release' do
          expect(subject).not_to receive(:create_github_release)
          subject.execute
        end
      end
    end

    context 'when tests fail' do
      before do
        allow(subject).to receive(:run_tests).and_return(false)
      end

      it 'aborts and returns 1' do
        expect(subject).not_to receive(:bump_version)
        expect(subject.execute).to eq(1)
      end
    end
  end
end
