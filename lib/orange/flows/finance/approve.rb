# typed: true

module Orange
  module Flows
    module Finance
      class Approve < Flow
        extend T::Sig

        sig do
          params(project: FinanceProject)
            .returns(T.any(
              Results::Success[[ FinanceProject, T::Array[Cmd] ]],
              Results::Failure[Symbol]
            ))
        end
        def call(project)
          flow do
            step validate_status(project)

            [ project.with(status: Project::Status::FinanceApproved),
              [ Cmd::Project::RefreshStatus.new(project.id) ]
            ]
          end
        end

        private

        def validate_status(project)
          unless project.status == Project::Status::FinanceApproval
            return Failure(:wrong_status)
          end

          Success(project)
        end
      end
    end
  end
end
