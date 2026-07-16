require "rails_helper"
require_relative "../../../../lib/results/result_matchers_spec.rb"

RSpec.describe Projects::Finance::Actions::Approve do
  include Results::Mixin

  subject(:action) do
    described_class.new(project_repo:, approve_finance: approve_finance_class, command_center:)
  end

# Arguments
let(:project_api_id) { "prj_123" }

# Dependencies
let(:project_repo) { class_double("FinanceProjectRepo") }
let(:approve_finance_class) { class_double("Orange::Flows::Finance::Approve") }
let(:approve_finance) { instance_double("Orange::Flows::Finance::Approve") }
let(:command_center) { class_double("CommandCenter") }

# Results
let(:project) do
  Orange::Project.new(api_id: project_api_id,
              status: Orange::Project::Status::FinanceApproval,
              office_key: "NJC",
              id: 1)
end

let(:approved_project) { project.with(status: Orange::Project::Status::FinanceApproved) }

let(:commands) do
  [ Orange::Cmd::Project::RefreshStatus.new(project.id) ]
end

before do
  allow(approve_finance_class).to receive(:new).and_return(approve_finance)
  allow(approve_finance).to receive(:call).with(project) { Success([ approved_project, commands ]) }
  allow(command_center).to receive(:dispatch)
end

context "with a project" do
    before do
      allow(project_repo).to receive(:get_by_api_id!).with(project_api_id) { project }
      allow(project_repo).to receive(:update_status).with(1, anything) { approved_project }
    end
    it "calls the the core with the project from the repo" do
      action.call(project_api_id:)

      expect(approve_finance).to have_received(:call).with(project)
    end

    context "when successful" do
      before do
        allow(approve_finance).to receive(:call).with(project) do
          Success([ approved_project, commands ])
        end
      end

        it "updates the project status to 'Finance Approved'" do
          action.call(project_api_id:)

          expect(project_repo).to have_received(:update_status)
            .with(project.id, Orange::Project::Status::FinanceApproved)
        end
        it "handles the commands" do
          action.call(project_api_id:)
          expect(command_center).to have_received(:dispatch).with(commands)
        end

        it "returns the project with approved status successfully" do
          result = action.call(project_api_id:)

          expect(result).to succeed_with(approved_project)
        end
      end

      context "when unsuccessful" do
        before do
          allow(approve_finance).to receive(:call).with(project) do
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
