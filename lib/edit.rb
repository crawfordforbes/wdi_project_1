require 'active_record'
require 'pry'
require 'markdown'


class Edit < ActiveRecord::Base
	def content_html
		html = Markdown.new(self.old_entry).to_html
		return html
	end
end