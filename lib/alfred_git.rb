require 'YAML'
require 'fileutils'
require 'find'
require 'iamsellek_cl_helper'

require_relative './alfred_git/version'

module AlfredGit
  class AlfredGit
    include AlfredGitVersion
    include IamsellekClHelper

    def initialize
      set_app_directory

      # If there's just one, it's the current version.
      restore_settings('alfred_git', VERSION) if
        Dir.glob("#{@app_directory.chomp("/alfred_git-#{VERSION}")}/alfred_git*").length > 1 &&
        !(File.exists?("#{@app_directory}/lib/config.yaml"))

      config unless File.exists?("#{@app_directory}/lib/config.yaml")
      config_yaml = YAML.load_file("#{@app_directory}/lib/config.yaml")

      @repo_locations = config_yaml['repos']
      @name = config_yaml['name'].nil? ? 'Wayne' : config_yaml['name']
      @gender = config_yaml['gender'].nil? ? 'sir' : config_yaml['gender']
    end

    def alfred(arguments)
      @arguments = arguments
      alfred_command
      command = command_to_git_command
      repos = repos_string_to_array

      repos.each do |repo|
        lines_pretty_print Rainbow("Repo #{repo}:").yellow
        bash(@repo_locations[repo], command)

        single_space
      end
    end

    def alfred_command
      case @arguments[0]
      when nil, ''
        lines_pretty_print Rainbow("I need a command to run, Master #{@name}.").red

        abort
      when 'list_repo', 'list_repos', 'listrepo', 'listrepos', 'lr'
        lines_pretty_print "Here are your repos and their locations, Master #{@name}:"

        single_space

        list_repos_and_locations

        single_space

        abort
      when 'add_repo', 'addrepo', 'ar'
        if second_argument_missing?(@arguments)
          lines_pretty_print Rainbow("I need a repo name for the new repo, Master #{@name}.").red

          abort
        end

        add_repo

        abort
      when 'delete_repo', 'deleterepo', 'deletrepo', 'dr'
        if second_argument_missing?(@arguments)
          lines_pretty_print Rainbow("I need a repo name to know which repo I'm deleting, Master #{@name}.").red

          abort
        end

        delete_repo

        abort
      when 'repo_add_directory', 'rad'
        
        if second_argument_missing?(@arguments)
          lines_pretty_print Rainbow("I need a directory path to know which repos to add, Master #{@name}.").red
        
          abort
        end

        repo_add_directory

        abort
      end
    end

    def list_repos_and_locations
      @repo_locations.each do |repo, location|
        lines_pretty_print Rainbow("#{repo}:").yellow + " #{location}"
      end
    end

    def add_repo
      repo_name = @arguments[1]

      single_space

      lines_pretty_print "I can add the #{repo_name} repo straight away, #{@gender}. Where is that repository? "\
                         'Please paste the full path.'

      repo_path = STDIN.gets.strip!

      single_space

      config_yaml = YAML.load_file("#{@app_directory}/lib/config.yaml")
      config_file = File.open("#{@app_directory}/lib/config.yaml", 'w')

      config_yaml['repos'][repo_name] = repo_path
      YAML.dump(config_yaml, config_file)

      lines_pretty_print Rainbow("I've added that repository successfully, #{@gender}!").green

      single_space
    end

    def delete_repo
      repo_name = @arguments[1]

      single_space

      config_yaml = YAML.load_file("#{@app_directory}/lib/config.yaml")
      config_file = File.open("#{@app_directory}/lib/config.yaml", 'w')
      
      if repo_name == 'all'
        config_yaml['repos'] = {}
        lines_pretty_print Rainbow("I've deleted all repositories successfully, #{@gender}!").green
      elsif config_yaml['repos'].keys.include?(repo_name)
        config_yaml['repos'].delete(repo_name)

        lines_pretty_print Rainbow("I've deleted that repository successfully, #{@gender}!").green
      else
        lines_pretty_print Rainbow("Sorry, #{@gender}, that is not a repository that is currently in my list. "\
                                   'If you\'d *really* like to delete it, please add it first using the '\
                                   '\'add_repo\' command.').red
      end

      YAML.dump(config_yaml, config_file)

      single_space
    end
    
    def repo_add_directory
      single_space

      if @arguments[1] == '.'
        rootDir = Dir.pwd
      else
        rootDir = @arguments[1]
      end

      repo_paths = []

      Find.find(rootDir) do |path|
        already_found_repo = false
        puts path

        repo_paths.each do |repo_path|
          already_found_repo = path.include?(repo_path)
        end

        next if already_found_repo

        if path =~ /.*\.git$/ && !already_found_repo
          repo_paths << path[0...-5]
        end
      end

      config_yaml = YAML.load_file("#{@app_directory}/lib/config.yaml")
      config_file = File.open("#{@app_directory}/lib/config.yaml", 'w')

      lines_pretty_print Rainbow("I've added the following repositories successfully, #{@gender}").green

      single_space

      repo_paths.each do |path|
        repo = path.split('/').last
        location = rootDir

        if config_yaml['repos'][repo] == nil
          config_yaml['repos'][repo] = path
          lines_pretty_print Rainbow(repo + ":").yellow + path
        else
          altPath = path
          altPath.slice! rootDir + "/"
          config_yaml['repos'][altPath] = rootDir + "/" + path
          lines_pretty_print Rainbow(altPath + ":").yellow + rootDir + "/" + path
        end
      end

      YAML.dump(config_yaml, config_file)
    end

    def command_to_git_command
      command = ''

      case @arguments[0]
      when 'pull'
        command = 'git pull'

        delete_arguments(@arguments, 1)
      when 'push'
        command = 'git push'

        delete_arguments(@arguments, 1)
      when 'checkout'
        if second_argument_missing?(@arguments)
          lines_pretty_print Rainbow('I need a branch name to execute the \'checkout\' command, Master '\
                                     "#{@name}.").red

          abort
        end

        command = "git checkout #{@arguments[1]}"

        delete_arguments(@arguments, 2)
      when 'commit'
        if second_argument_missing?(@arguments)
          lines_pretty_print Rainbow('I need a commit message to execute the \'commit\' command, Master '\
                                     "#{@name}.").red

          abort
        end

        command = %Q[git commit -m "#{@arguments[1]}"]

        delete_arguments(@arguments, 2)
      when 'status'
        command = 'git status'

        delete_arguments(@arguments, 1)
      when 'branches', 'branch'
        command = 'git rev-parse --abbrev-ref HEAD'

        delete_arguments(@arguments, 1)
      when 'woa', 'wielder_of_anor', 'wielderofanor'
        if second_argument_missing?(@arguments)
          lines_pretty_print Rainbow("I need a commit message to pass to wielder_of_anor, Master #{@name}.").red

          abort
        end

        if @arguments[2] && @arguments[2] == '1'
          command = %Q[wielder_of_anor "#{@arguments[1]}" 1]

          delete_arguments(@arguments, 3)
        else
          command = %Q[wielder_of_anor "#{@arguments[1]}"]

          delete_arguments(@arguments, 2)
        end
      else
        command = @arguments[0] # Allow users to send any command to all repos.

        delete_arguments(@arguments, 1)
      end

      command
    end

    # All other arguments are deleted before we get here, so this should be just the repo list.
    def repos_string_to_array
      if @arguments[0].nil?|| @arguments[0] == ''
        lines_pretty_print Rainbow("I need at least one repository to work with, Master #{@name}.").red

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

      name = name == '' ? 'Wayne' : name

      single_space

      lines_pretty_print 'Thank you, sir. You...are a sir, correct?'

      gender_set = false

      until gender_set
        gender = STDIN.gets.strip!

        single_space

        if gender == 'yes' || gender == 'y'
          gender = 'sir'
          gender_set = true
        elsif gender == 'no' || gender == 'n'
          gender = 'madam'
          gender_set = true
        else
          lines_pretty_print "Very funny, Master #{name}."
          lines_pretty_print Rainbow('Please input either \'yes\' or \'no\'.').yellow
        end
      end

      lines_pretty_print "Yes, of course. My apologies. Please do not take offense, #{gender}. I am, after "\
                         'all, a simple computer program. Don\'t have eyes, you see. Now, let\'s gather a '\
                         'list of the code repositories you work with, shall we?'

      single_space

      repos = {}
      done = false
      repo_count = 0

      until done do
        first = repo_count > 0 ? 'next' : 'first'

        lines_pretty_print "What is the 'friendly' name you'd like to give your #{first} repository? This is the "\
                           'name you will type when sending me commands. If you are done adding them, please just hit '\
                           'enter as your input instead.'

        repo_name = STDIN.gets.strip!

        if repo_name == ''
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

    def set_app_directory
      @app_directory = File.expand_path(File.dirname(__FILE__)).chomp('/lib')
    end
  end
end