# typed: ignore — Orange::Cmd::Project::Mystery is stub_const'd, which static analysis can't see
require "rails_helper"

RSpec.describe ProjectCommand do
  describe ".dispatch" do
    # These pin the exhaustive match only — the effect of each command is
    # asserted once it's implemented.
    it "handles CancelActivePiiVisit" do
      expect { described_class.dispatch(Orange::Cmd::Project::CancelActivePiiVisit.new(1)) }
        .not_to raise_error
    end

    it "handles CancelProjectVisits" do
      expect { described_class.dispatch(Orange::Cmd::Project::CancelProjectVisits.new(1)) }
        .not_to raise_error
    end

    it "handles RefreshStatus" do
      expect { described_class.dispatch(Orange::Cmd::Project::RefreshStatus.new(1)) }
        .not_to raise_error
    end

    context "with a project command it doesn't handle" do
      before { stub_const("Orange::Cmd::Project::Mystery", Class.new(Orange::Cmd::Project)) }

      it "fails fast" do
        expect { described_class.dispatch(Orange::Cmd::Project::Mystery.new(1)) }
          .to raise_error(NoMatchingPatternError)
      end
    end
  end
end
