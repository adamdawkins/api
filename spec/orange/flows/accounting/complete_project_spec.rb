require "orange_helper"
require "support/result_matchers"

module Orange
  RSpec.shared_examples "success from parent of qc"  do
    it "returns a success" do
      expect(flow.call(project)).to be_success
    end

    describe "model" do
      it "returns the project with the paid and complete status" do
        model, _ = flow.call(project).value!

        expect(model.status).to eq Project::Status::PaidAndComplete
      end
    end

    describe "commands" do
      it "returns a command to refresh the qc project status" do
        _, cmds = flow.call(project).value!
        expect(cmds).to include(Cmd::Project::RefreshStatus.new(related_project_id))
      end
    end
  end

  RSpec.describe Flows::Accounting::CompleteProject do
    subject(:flow) { described_class.new }

    describe "#call" do
      let(:project) do
        AccountingProject.new(id: 1,
                              related_project_id:,
                              collect_funds_independently:,
                              qc:,
                              status:,
                              agreements:,
                              related_agreements:
                             )
      end

      let(:collect_funds_independently) { false }
      let(:agreements) { [] }
      let(:related_agreements) { [] }

      context "with a funds requested project" do
        let(:status) { Project::Status::FundsRequested }

        context "with a non-qc project" do
          let(:qc) { false }

          context "with a qc project for the project" do
            let(:related_project_id) { 2 }

            context "when funds are collected independently" do
              let(:collect_funds_independently) { true }

              context "with all project agreements paid" do
                let(:agreements) do
                  [ Agreement.new(id: 1, paid: true),
                    Agreement.new(id: 2, paid: true) ]
                end

                include_examples "success from parent of qc"
              end

              context "without all project agreements paid" do
                let(:agreements) do
                  [ Agreement.new(id: 1, paid: true),
                    Agreement.new(id: 2, paid: false) ]
                end

                it "returns a failure" do
                  expect(flow.call(project)).to fail_with(:agreements_unpaid)
                end
              end
            end

            context "when funds are collected dependently" do
              let(:collect_funds_independently) { false }

              context "with all project agreements paid" do
                let(:agreements) do
                  [ Agreement.new(id: 1, paid: true),
                    Agreement.new(id: 2, paid: true) ]
                end

                context "with all qc project agreements paid" do
                  let(:related_agreements) do
                    [ Agreement.new(id: 3, paid: true),
                      Agreement.new(id: 4, paid: true) ]
                  end

                  include_examples "success from parent of qc"
                end

                context "without all qc project agreements paid" do
                  let(:related_agreements) do
                    [ Agreement.new(id: 3, paid: true),
                      Agreement.new(id: 4, paid: false) ]
                  end

                  it "returns a failure" do
                    expect(flow.call(project)).to fail_with(:agreements_unpaid)
                  end
                end
              end

              context "without all project agreements paid" do
                let(:agreements) do
                  [ Agreement.new(id: 1, paid: true),
                    Agreement.new(id: 2, paid: false) ]
                end

                context "with all qc project agreements paid" do
                  let(:related_agreements) do
                    [ Agreement.new(id: 3, paid: true),
                      Agreement.new(id: 4, paid: true) ]
                  end

                  it "returns a failure" do
                    expect(flow.call(project)).to fail_with(:agreements_unpaid)
                  end

                  context "without all qc project agreements paid" do
                    let(:related_agreements) do
                      [ Agreement.new(id: 3, paid: true),
                        Agreement.new(id: 4, paid: false) ]
                    end

                    it "returns a failure" do
                      expect(flow.call(project)).to fail_with(:agreements_unpaid)
                    end
                  end
                end
              end
            end
            end

          context "without a qc project for the project" do
            let(:related_project_id) { nil }
            let(:related_agreements) { [] }

            context "with all project agreements paid" do
              let(:agreements) do
                [ Agreement.new(id: 1, paid: true),
                  Agreement.new(id: 2, paid: true) ]
              end

              it "returns a success" do
                expect(flow.call(project)).to be_success
              end

              describe "model" do
                it "returns the project with the paid and complete status" do
                  model, _ = flow.call(project).value!

                  expect(model.status).to eq Project::Status::PaidAndComplete
                end
              end

              describe "commands" do
                it "returns no commands" do
                  _, cmds = flow.call(project).value!
                  expect(cmds).to eq []
                end
              end
            end

            context "without all project agreements paid" do
              let(:agreements) do
                [ Agreement.new(id: 1, paid: true),
                  Agreement.new(id: 2, paid: false) ]
              end

              it "returns a failure" do
                expect(flow.call(project)).to fail_with(:agreements_unpaid)
              end
            end
          end
        end

      context "with a qc project" do
        let(:qc) { true }
        let(:related_project_id) { 3 }

        context "when funds are collected independently" do
          let(:collect_funds_independently) { true }

          context "with all project agreements paid" do
            let(:agreements) do
              [ Agreement.new(id: 1, paid: true),
                Agreement.new(id: 2, paid: true) ]
            end

            it "returns a success" do
              expect(flow.call(project)).to be_success
            end

            describe "model" do
              it "returns the project with the completed status" do
                model, _ = flow.call(project).value!

                expect(model.status).to eq Project::Status::PaidAndComplete
              end
            end

            describe "commands" do
              it "returns a command to refresh the parent project status" do
                _, cmds = flow.call(project).value!
                expect(cmds).to include(Cmd::Project::RefreshStatus.new(project.related_project_id))
              end
            end
          end

          context "without all project agreements paid" do
            let(:agreements) do
              [ Agreement.new(id: 1, paid: true),
                Agreement.new(id: 2, paid: false) ]
            end

            it "returns a failure" do
              expect(flow.call(project)).to fail_with(:agreements_unpaid)
            end
          end
        end

          context "when funds are not collected independently" do
            let(:collect_funds_independently) { false }
            it "returns a failure" do
              expect(flow.call(project)).to fail_with(:funds_collected_dependently)
            end
          end
        end
      end
    end
    context "without a funds requested project" do
      it "returns a failure for every other status" do
        (Project::Status.values - [ Project::Status::FundsRequested ]).each do |status|
          project = AccountingProject.new(id: 1,
                                          related_project_id: 2,
                                          collect_funds_independently: true,
                                          qc: false,
                                          status: status,
                                          agreements: [],
                                          related_agreements: [])

          expect(flow.call(project)).to fail_with(:wrong_status)
        end
      end
    end
  end
end
