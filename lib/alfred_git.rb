require 'YAML'
require 'rainbow'

module AlfredGit
  class AlfredGit

    def initialize
      set_app_directory
      config_yaml = YAML.load_file("#{@app_directory}/lib/config.yaml")

      config if config_yaml.nil? || !config_yaml

      @repo_locations = config_yaml['repos']
      @name = config_yaml['name'].nil? ? 'Wayne' : config_yaml['name']
      @gender = config_yaml['gender'].nil? ? 'sir' : config_yaml['gender']
    end

    def alfred(arguments)
      @arguments = arguments
      command = command_to_git_command
      repos = repos_string_to_array

      repos.each do |repo|
        lines_pretty_print Rainbow("Repo #{repo}:").yellow
        bash(@repo_locations[repo], command)

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
      when 'status'
        command = 'git status'
        @arguments.delete_at(0)
      when 'branches', 'branch'
        command = 'git rev-parse --abbrev-ref HEAD'
        @arguments.delete_at(0)
      else
        command = @arguments[0] # Allow users to send any command to all repos.
        @arguments.delete_at(0)
      end

      command
    end

    # All other arguments are deleted before we get here, so this should be just the repo list.
    def repos_string_to_array
      if @arguments[0].nil?|| @arguments[0] == ''
        lines_pretty_print Rainbow('I need at least one repository to work with, Master Wayne.').red

        abort
      elsif @arguments[0] == 'all'
        return @repo_locations.keys
      else
        return @arguments
      end
    end

    def config
      config_file = File.open("#{@app_directory}/lib/config.yaml", 'w')

      lines_pretty_print 'Good evening, Master Wayne. Thank you for utilizing my abilities. Please enter your '\
                         'last name if you\'d like me to address you as something other than Wayne.'
      lines_pretty_print Rainbow('(Just hit enter to stick with \'Master Wayne\'.)').yellow

      name = STDIN.gets.strip!

      single_space

      lines_pretty_print 'Thank you, sir. You...are a sir, correct?'

      gender = STDIN.gets.strip!

      gender = gender =='yes' || gender == 'y' ? 'sir' : 'madam'

      single_space

      lines_pretty_print "Thank you, #{gender}. Now, let's gather a list of the code repositories you work "\
                         'with, shall we?'

      single_space

      repos = {}
      done = false
      repo_count = 0

      until done do
        first = repo_count > 0 ? 'next' : 'first'

        lines_pretty_print "What is the 'friendly' name you'd like to give your #{first} repository? This is the "\
                           'name you will type when sending me commands. If you are done adding them, please '\
                           'enter \'x211\' as your input instead.'

        repo_name = STDIN.gets.strip!

        if repo_name == 'x211'
          done = true
          single_space
          next
        end

        single_space

        lines_pretty_print "Thank you, #{gender}. Now, where is that repository? Please paste the full path."

        repo_path = STDIN.gets.strip!

        single_space

        repos[repo_name] = repo_path
        repo_count += 1

        lines_pretty_print Rainbow("I've added that repository successfully, #{gender}!").green

        single_space
      end

      YAML.dump({ 'name' => name, 'gender' => gender, 'repos' => repos }, config_file)
      config_file.close

      lines_pretty_print "Thank you for helping me set things up, Master #{name}. Feel free to run me whenever "\
                         'you need.'

      abort
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
      @app_directory = File.expand_path(File.dirname(__FILE__)).chomp('/lib')
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
end