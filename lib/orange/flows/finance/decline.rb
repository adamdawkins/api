# typed: true

module Orange
  module Flows
    module Finance
      class Decline < Flow
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

            [ project.with(status: Project::Status::FinanceDecline),
              [ Cmd::Project::CancelPiiVisits.new(project.id),
                Cmd::Project::CancelProjectVisits.new(project.id) ]
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
