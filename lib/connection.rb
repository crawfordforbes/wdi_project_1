require 'active_record'
require 'markdown'

ActiveRecord::Base.establish_connection({
	:adapter => "postgresql",
	:host => "localhost",
	:username => "crawford",
	:database => "afd"
	})

ActiveRecord::Base.logger = Logger.new(STDOUT)