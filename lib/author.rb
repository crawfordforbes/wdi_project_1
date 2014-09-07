require 'active_record'
require 'pry'
require_relative './doc'

class Author < ActiveRecord::Base
	def docs
		return Doc.where(author_id: self.id)
	end
end