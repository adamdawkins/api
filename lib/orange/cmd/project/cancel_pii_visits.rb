# typed: true

module Orange
  class Cmd
    class Project
      # Cancel any PII visits scheduled for the project.
      #
      #   Cmd::Project::CancelPiiVisits.new(project.id)
      class CancelPiiVisits < Project
      end
    end
  end
end
