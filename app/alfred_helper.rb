require 'YAML'

class AlfredHelper

  def initialize(arguments)
    @app_directory = File.expand_path(File.dirname(__FILE__)).chomp('/app')
    @arguments = arguments
    repo_locations = YAML.load_file("#{@app_directory}/config/repos.yaml")
    command = command_to_git_command
    repos = repos_string_to_array(repo_locations)

    repos.each do |repo|
      bash(repo_locations[repo], command)
    end
  end

  def command_to_git_command
    command = ''

    case @arguments[0]
    when nil || ''
      puts 'I need a command to run, Master Wayne.'
      abort
    when 'pull'
      command = 'git pull'
      @arguments.delete_at(0)
    when 'push'
      command = 'git push'
      @arguments.delete_at(0)
    when 'commit'
      command = 'git commit'
      @arguments.delete_at(0)
    when 'checkout'
      if @arguments[1].nil? || @arguments[1] == ''
        puts "I need a branch name to execute the 'checkout' command, Master"\
             " Wayne."
        abort
      end

      command = "git checkout #{@arguments[1]}"

      @arguments.delete_at(0)
      @arguments.delete_at(0)
    end

    return command
  end

  def repos_string_to_array(repo_locations)
    if @arguments[0].nil? || @arguments[0] == ''
      puts "I need at least one repository to work with, Master Wayne."
      abort
    elsif @arguments[0] == 'all'
      return repo_locations.keys
    else
      return @arguments
    end
  end

  def bash(directory, command)
    # Dir.chdir ensures all bash commands are being run from the correct
    # directory.
    Dir.chdir(directory) { system "#{command}" }
  end

  # def self.config_exist?
  #   !(File.exist? 'config/repos.yaml')
  # end
  #
  # def self.first_run
  #   puts "Good evening. May I please have your last name? (Hit enter to"\
  #        " default to Wayne.)"
  #   name = STDIN.gets.strip!
  #   name = "Wayne" if name == ""
  #
  #   puts "Thank you, Master #{name}. Now, let's gather a list of your code"\
  #        " repository locations and their shortcut names. I'll collect them"\
  #        " from you one by one. Go ahead and submit x211 as your input"\
  #        " whenever we have finished the list."
  #   STDIN.gets
  #
  #   done = false
  #   locations = []
  #   names = []
  #
  #   while !done do
  #     puts "Enter a code repository location."
  #
  #   end
  # end
end
