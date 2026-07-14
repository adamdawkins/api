# typed: true

# Routes the commands a core flow returns to the handler for their family.
class CommandCenter
  extend T::Sig

  sig do
    params(cmds: T::Array[Orange::Cmd],
           project_command: T.class_of(ProjectCommand)).void
  end
  def self.dispatch(cmds, project_command: ProjectCommand)
    cmds.each do |cmd|
      case cmd
      in Orange::Cmd::Project => project_cmd then project_command.dispatch(project_cmd)
      end
    end
  end
end
