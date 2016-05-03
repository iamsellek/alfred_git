require_relative 'alfred_helper'

# AlfredHelper.first_run unless AlfredHelper.config_exist?

helper = AlfredHelper.new(ARGV)
