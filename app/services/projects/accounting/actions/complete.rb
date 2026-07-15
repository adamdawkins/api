# typed: strict

module Projects
 module Accounting
   module Actions
     class Complete
        extend T::Sig
        include Results::Mixin

        sig do
          params(command_center:   T.class_of(CommandCenter),
                 complete_project: T.class_of(Orange::Flows::Accounting::CompleteProject),
                 project_repo:     T.class_of(AccountingProjectRepo))
            .void
        end
        def initialize(command_center:  CommandCenter,
                       complete_project: Orange::Flows::Accounting::CompleteProject,
                       project_repo:    AccountingProjectRepo)
          @command_center =   T.let(command_center, T.class_of(CommandCenter))
          @complete_project = T.let(complete_project.new,
                                    Orange::Flows::Accounting::CompleteProject)
          @project_repo =     T.let(project_repo,   T.class_of(AccountingProjectRepo))
       end

        sig do
           params(project_api_id: String)
             .returns(T.any(Results::Success[Orange::AccountingProject],
                            Results::Failure[Symbol]))
        end
        def call(project_api_id:)
          project = @project_repo.by_api_id(project_api_id)

          result = @complete_project.call(project)
          case result
          when Results::Success
            completed_project, commands = result.value!

            @project_repo.update_status(completed_project.id, completed_project.status)
            @command_center.dispatch(commands)

            Success(completed_project)
          when Results::Failure
            result
          else
            T.absurd(result)
          end
        end
     end
   end
 end
end
