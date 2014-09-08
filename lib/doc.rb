require 'active_record'
require 'pry'

class Doc < ActiveRecord::Base
	def next
	  nextDoc = Doc.where("docs.id > ?", self.id).order("docs.id ASC").limit(1)
	  return nextDoc[0]["id"]
	end

	def previous
	  prevDoc = Doc.where("docs.id < ?", self.id).order("docs.id DESC").limit(1)
	  return prevDoc[0]["id"]
	end

	def content_html
		html = Markdown.new(self.content).to_html
		return html
	end
end
