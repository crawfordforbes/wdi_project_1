require 'active_record'
require_relative './doc'

class Subscriber < ActiveRecord::Base
		def docs
		return Doc.where(sub_ids: self["name"])
	end
end