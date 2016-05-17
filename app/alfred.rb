require_relative 'alfred_helper'

helper = AlfredHelper.new

helper.config if ARGV[0] == 'config'

helper.alfred(ARGV)