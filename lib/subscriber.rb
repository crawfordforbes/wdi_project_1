require 'active_record'
require_relative './docsub'

class Subscriber < ActiveRecord::Base
	def docs
		Docsub.where(sub_id: self.id)
end
end