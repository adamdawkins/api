# typed: strict

module Operations
  module Projects
    class CancelActivePiiVisit
      extend T::Sig

      sig do
        params(pii_visit_repo:       T.class_of(PiiVisitRepo),
               optimo_route_deleter: T.class_of(Operations::Projects::DeleteOptimoRoute))
          .void
      end
      def initialize(pii_visit_repo: PiiVisitRepo,
                     optimo_route_deleter: Operations::Projects::DeleteOptimoRoute)
        @pii_visit_repo = pii_visit_repo
        @optimo_route_deleter = optimo_route_deleter
      end

      sig { params(project_id: Integer).void }
      def self.perform_later(project_id)
        OperationJob.perform_later(project_id, operation: self)
      end

      sig { params(project_id: Integer).returns(Orange::PiiVisit) }
      def call(project_id)
        pii_visit = @pii_visit_repo.get_active_for_project!(project_id)

        updated_pii_visit = @pii_visit_repo.update_status(pii_visit.id,
                                                          Orange::PiiVisit::Status::Cancelled)

        @optimo_route_deleter.perform_later(project_id)

        updated_pii_visit
      end
    end
  end
end
