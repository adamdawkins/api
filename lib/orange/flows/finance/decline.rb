module Orange
  module Flows
    module Finance
      class Decline
        def call(project)
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
