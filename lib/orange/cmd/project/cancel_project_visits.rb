# typed: true

module Orange
  class Cmd
    class Project
      # Cancel any Project visits scheduled for the project.
      #
      #   Cmd::Project::CancelPiiVisits.new(project.id)
      class CancelProjectVisits < Project
      end
    end
  end
end
