# typed: strict

module Orange
  class Cmd
    # Commands about a Project. Abstract: match the family with
    # `in Cmd::Project`, instantiate only the concrete commands below it.
    class Project < Cmd
      abstract!
    end
  end
end
