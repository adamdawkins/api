# typed: strict

module Projects
 module Finance
   module Actions
     class Approve
        extend T::Sig
        include Results::Mixin

        sig do
          params(approve_finance: T.class_of(Orange::Flows::Finance::Approve),
                 command_center:  T.class_of(CommandCenter),
                 project_repo:    T.class_of(FinanceProjectRepo))
            .void
        end
        def initialize(approve_finance: Orange::Flows::Finance::Approve,
                       command_center:  CommandCenter,
                       project_repo:    FinanceProjectRepo)
          @approve_finance = T.let(approve_finance.new, Orange::Flows::Finance::Approve)
          @command_center =  T.let(command_center,      T.class_of(CommandCenter))
          @project_repo =    T.let(project_repo,        T.class_of(FinanceProjectRepo))
       end

       sig do
          params(project_api_id: String)
            .returns(T.any(Results::Success[Orange::FinanceProject],
                           Results::Failure[Symbol]))
       end
        def call(project_api_id:)
          project = @project_repo.by_api_id(project_api_id)
          result = @approve_finance.call(project)

          case result
          when Results::Success
            approved_project, commands = result.value!

            @project_repo.update_status(approved_project.id, approved_project.status)
            @command_center.dispatch(commands)

            Success(approved_project)
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
