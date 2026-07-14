# typed: strict

# Performs the effect each Orange::Cmd::Project command asks for.
class ProjectCommand
  extend T::Sig

  sig { params(cmd: Orange::Cmd::Project).void }
  def self.dispatch(cmd)
    case cmd
    in Orange::Cmd::Project::CancelPiiVisits
      # TODO: cancel the project's PII visits
    in Orange::Cmd::Project::CancelProjectVisits
      # TODO: cancel the project's visits
    in Orange::Cmd::Project::RefreshStatus
      # TODO: refresh the project's status
    end
  end
end
