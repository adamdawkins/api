require "orange_helper"
require "support/result_matchers"

module Orange
  RSpec.describe Flows::Finance::Decline do
    subject(:flow) { described_class.new }

    describe "#call" do
      let(:project) { FinanceProject.new(id: 1, status:) }

      context "with a project in finance approval" do
        let(:status) { Project::Status::FinanceApproval }

        it "returns a success" do
          expect(flow.call(project)).to be_success
        end

        describe "model" do
          it "returns the project with the finance decline status" do
            model, _ = flow.call(project).value!

            expect(model.status).to eq Project::Status::FinanceDecline
          end
        end

        describe "commands" do
          it "returns the command for cancelling pii visits" do
            _, cmds = flow.call(project).value!
            expect(cmds).to include(Cmd::Project::CancelPiiVisits)
          end

          it "returns the command for cancelling project visits" do
            _, cmds = flow.call(project).value!
            expect(cmds).to include(Cmd::Project::CancelProjectVisits)
          end
        end
      end

     context "with a project in any other status" do
        it "returns a failure for every other status" do
          (Project::Status.values - [ Project::Status::FinanceApproval ]).each do |status|
            project = FinanceProject.new(id: 1, status:)

            result = flow.call(project)

            expect(result).to fail_with(:wrong_status)
          end
        end
      end
    end
  end
end
