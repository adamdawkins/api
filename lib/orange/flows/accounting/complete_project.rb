# typed: strict

module Orange
  module Flows
    module Accounting
      class CompleteProject < Flow
        extend T::Sig

        sig do
          params(project: AccountingProject)
            .returns(T.any(
              Results::Success[[ AccountingProject, T::Array[Cmd] ]],
              Results::Failure[Symbol]
            ))
        end
        def call(project)
          flow do
            step validate_status(project)
            step validate_collectable_project(project)

            agreements = collectable_agreements(project)
            step validate_all_agreements_paid(agreements)

            cmds = [ refresh_status_cmd(project) ].compact

            [ project.with(status: Project::Status::PaidAndComplete),
              cmds
            ]
          end
        end

        private

        sig do params(project: AccountingProject)
          .returns(T.any(Results::Success[T::Boolean],
                         Results::Failure[Symbol]))
        end
        def validate_status(project)
          if project.status == Project::Status::FundsRequested
            Success(true)
          else
            Failure(:wrong_status)
          end
        end

        sig do params(project: AccountingProject)
          .returns(T.any(Results::Success[T::Boolean],
                         Results::Failure[Symbol]))
        end
        def validate_collectable_project(project)
          if project.qc && !project.collect_funds_independently
            Failure(:funds_collected_dependently)
          else
            Success(true)
          end
        end

        sig do params(agreements: T::Array[Agreement])
          .returns(T.any(Results::Success[T::Boolean],
                         Results::Failure[Symbol]))
        end
        def validate_all_agreements_paid(agreements)
          unless agreements.all?(&:paid)
            return Failure(:agreements_unpaid)
          end

          Success(true)
        end

        sig { params(project: AccountingProject).returns(T::Array[Agreement]) }
        def collectable_agreements(project)
          if project.collect_funds_independently
            project.agreements
          else
            project.agreements + project.related_agreements
          end
        end

        sig do
          params(project: AccountingProject)
            .returns(T.nilable(Cmd::Project::RefreshStatus))
        end
        def refresh_status_cmd(project)
          return unless project.related_project_id

          Cmd::Project::RefreshStatus.new(project.related_project_id)
        end
      end
    end
  end
end
