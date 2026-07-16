require "rails_helper"
require_relative "../../../../lib/results/result_matchers_spec.rb"

RSpec.describe Projects::Finance::Actions::Decline do
  include Results::Mixin

  subject(:action) do
    described_class.new(project_repo:, decline_finance: decline_finance_class, command_center:)
  end

# Arguments
let(:project_api_id) { "prj_123" }

# Dependencies
let(:project_repo) { class_double("FinanceProjectRepo") }
let(:decline_finance_class) { class_double("Orange::Flows::Finance::Decline") }
let(:decline_finance) { instance_double("Orange::Flows::Finance::Decline") }
let(:command_center) { class_double("CommandCenter") }

# Results
let(:project) do
  Orange::Project.new(api_id: project_api_id,
              status: Orange::Project::Status::FinanceApproval,
              office_key: "NJC",
              id: 1)
end

let(:declined_project) { project.with(status: Orange::Project::Status::FinanceDecline) }

let(:commands) do
  [ Orange::Cmd::Project::CancelProjectVisits.new(project.id) ]
end

before do
  allow(decline_finance_class).to receive(:new).and_return(decline_finance)
  allow(decline_finance).to receive(:call).with(project) { Success([ declined_project, commands ]) }
  allow(command_center).to receive(:dispatch)
end

context "with a project" do
    before do
      allow(project_repo).to receive(:get_by_api_id!).with(project_api_id) { project }
      allow(project_repo).to receive(:update_status).with(1, anything) { declined_project }
    end
    it "calls the the core with the project from the repo" do
      action.call(project_api_id:)

      expect(decline_finance).to have_received(:call).with(project)
    end

    context "when successful" do
      before do
        allow(decline_finance).to receive(:call).with(project) do
          Success([ declined_project, commands ])
        end
      end

        it "updates the project status to 'Finance Declined'" do
          action.call(project_api_id:)

          expect(project_repo).to have_received(:update_status)
            .with(project.id, Orange::Project::Status::FinanceDecline)
        end
        it "handles the commands" do
          action.call(project_api_id:)
          expect(command_center).to have_received(:dispatch).with(commands)
        end

        it "returns the project with declined status successfully" do
          result = action.call(project_api_id:)

          expect(result).to succeed_with(declined_project)
        end
      end

      context "when unsuccessful" do
        before do
          allow(decline_finance).to receive(:call).with(project) do
            Failure(:wrong_status)
          end
        end

        it "returns a Failure with the error message" do
          result = action.call(project_api_id:)

          expect(result).to be_a_failure
          expect(result.failure).to eq(:wrong_status)
        end
      end
      end
      # We don't need to handle `without a project` because
      # FinanceProjectRepo.get_by_api_id! raises.
    end
