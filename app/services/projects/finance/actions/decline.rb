# typed: strict

module Projects
  module Finance
    module Actions
      class Decline
        extend T::Sig
        include Results::Mixin

        sig do
          params(command_center: T.class_of(CommandCenter),
                 decline_finance: T.class_of(Orange::Flows::Finance::Decline),
                 project_repo: T.class_of(FinanceProjectRepo))
            .void
        end
        def initialize(command_center: CommandCenter,
                       decline_finance: Orange::Flows::Finance::Decline,
                       project_repo: FinanceProjectRepo)
          @command_center = T.let(command_center, T.class_of(CommandCenter))
          @decline_finance = T.let(decline_finance.new, Orange::Flows::Finance::Decline)
          @project_repo = T.let(project_repo, T.class_of(FinanceProjectRepo))
        end

        sig do
          params(project_api_id: String)
            .returns(T.any(Results::Success[Orange::FinanceProject],
                           Results::Failure[Symbol]))
        end
        def call(project_api_id:)
          project = @project_repo.by_api_id(project_api_id)
          result = @decline_finance.call(project)

          case result
          when Results::Success
            declined_project, commands = result.value!

            @project_repo.update_status(declined_project.id, declined_project.status)
            @command_center.dispatch(commands)

            Success(declined_project)
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
