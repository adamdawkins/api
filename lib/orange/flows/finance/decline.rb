module Orange
  module Flows
    module Finance
      class Decline
        def call(project)
          unless project.status == Project::Status::FinanceApproval
            return Results::Failure.new(:wrong_status)
          end

          Results::Success.new([
            FinanceProject.new(id: project.id,
                               status: Project::Status::FinanceDecline),
                               [ Cmd::Project::CancelPiiVisits.new(project.id),
                                 Cmd::Project::CancelProjectVisits.new(project.id)
                               ]
          ])
        end
      end
    end
  end
end
