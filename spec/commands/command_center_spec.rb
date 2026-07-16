# typed: ignore — Orange::Cmd::Mystery is stub_const'd, which static analysis can't see
require "rails_helper"

RSpec.describe CommandCenter do
  describe ".dispatch" do
    let(:project_command) { class_double("ProjectCommand") }

    before { allow(project_command).to receive(:dispatch) }

    context "with project commands" do
      let(:commands) do
        [ Orange::Cmd::Project::CancelActivePiiVisit.new(1),
          Orange::Cmd::Project::CancelProjectVisits.new(1) ]
      end

      it "hands each one to ProjectCommand" do
        described_class.dispatch(commands, project_command:)

        expect(project_command).to have_received(:dispatch)
          .with(Orange::Cmd::Project::CancelActivePiiVisit.new(1)).ordered
        expect(project_command).to have_received(:dispatch)
          .with(Orange::Cmd::Project::CancelProjectVisits.new(1)).ordered
      end
    end

    context "with a command family it doesn't route" do
      before { stub_const("Orange::Cmd::Mystery", Class.new(Orange::Cmd)) }

      it "fails fast" do
        expect { described_class.dispatch([ Orange::Cmd::Mystery.new(1) ], project_command:) }
          .to raise_error(NoMatchingPatternError)
      end
    end
  end
end
