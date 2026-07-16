# typed: strict

module Orange
  class Cmd
    class Project
      # Cancel the active PII Visit for the project
      #
      #   Cmd::Project::CancelActivePiiVisit.new(project.id)
      class CancelActivePiiVisit < Project
      end
    end
  end
end
