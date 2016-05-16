require 'YAML'
require 'rainbow'

class AlfredHelper

  def alfred(arguments)
    set_app_directory

    @arguments = arguments
    repo_locations = YAML.load_file("#{@app_directory}/config/repos.yaml")
    command = command_to_git_command
    repos = repos_string_to_array(repo_locations)

    repos.each do |repo|
      lines_pretty_print Rainbow("Repo #{repo}:").yellow
      bash(repo_locations[repo], command)

      single_space
    end
  end

  def command_to_git_command
    command = ''

    case @arguments[0]
    when nil, ''
      lines_pretty_print Rainbow('I need a command to run, Master Wayne.').red

      abort
    when 'pull'
      command = 'git pull'
      @arguments.delete_at(0)
    when 'push'
      command = 'git push'
      @arguments.delete_at(0)
    when 'checkout'
      if second_argument_missing?
        lines_pretty_print Rainbow('I need a branch name to execute the \'checkout\' command, Master '\
                                   'Wayne.').red

        abort
      end

      command = "git checkout #{@arguments[1]}"

      @arguments.delete_at(0)
      @arguments.delete_at(0)
    when 'commit'
      if second_argument_missing?
        lines_pretty_print Rainbow('I need a commit message to execute the \'commit\' command, Master '\
                                   'Wayne.').red

        abort
      end

      command = %Q[git commit -m "#{@arguments[1]}"]
    when 'branches', 'branch'
      command = 'git rev-parse --abbrev-ref HEAD'
      @arguments.delete_at(0)
    else
        lines_pretty_print Rainbow('I do not recognize that command, Master Wayne.').red

        abort
    end

    command
  end

  # All other arguments are deleted before we get here, so this should be just the repo list.
  def repos_string_to_array(repo_locations)
    if @arguments[0].nil?|| @arguments[0] == ''
      lines_pretty_print Rainbow('I need at least one repository to work with, Master Wayne.').red

      abort
    elsif @arguments[0] == 'all'
      return repo_locations.keys
    else
      return @arguments
    end
  end

  def second_argument_missing?
    @arguments[1].nil? || @arguments[1] == ''
  end

  def bash(directory, command)
    # Dir.chdir ensures all bash commands are being run from the correct
    # directory.
    Dir.chdir(directory) { system "#{command}" }
  end

  def set_app_directory
    @app_directory = File.expand_path(File.dirname(__FILE__)).chomp('/app')
  end

  def lines_pretty_print(string)
    lines = string.scan(/\S.{0,70}\S(?=\s|$)|\S+/)

    lines.each { |line| puts line }
  end

  def single_space
    puts ''
  end

  def double_space
    puts "\n\n"
  end

  def surround_by_double_space(string)
    double_space
    lines_pretty_print(string)
    double_space
  end
end
