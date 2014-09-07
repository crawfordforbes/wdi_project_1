require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'markdown'
require_relative './lib/connection'
require_relative './lib/author'
require_relative './lib/doc'
require_relative './lib/subscriber'

after do 
	ActiveRecord::Base.connection.close
end

get("/") do 
	erb(:index, locals: {doc: Doc.all()})
end

get("/authors") do 
	erb(:"authors/index", locals: {doc: Doc.all(), authors: Author.all()})
end

post("/authors") do 
	Author.create(name: params["name"])
	redirect "/authors"
end

get("/authors/:id") do
	thisAuth = Author.find_by(id: params[:id])
	erb(:"authors/author", locals: {thisAuth: thisAuth, doc: Doc.all()})
end

put("/authors/:id") do 
	updateAuth = Author.find_by(id: params["id"])
	updateAuth.update(name: params["name"])
	redirect "/authors"
end

get("/subscribers") do
	erb(:"subscribers/index", locals: {doc: Doc.all(), subscribers: Subscriber.all()})
end

post("/subscribers") do 
	newSub = {
		name: params["name"],
		email: params["email"],
		phone: params["phone"]
	}
	Subscriber.create(newSub)
	redirect "/subscribers"
end

get("/subscribers/:id") do 
	thisSub = Subscriber.find_by(id: params[:id])
	erb(:"subscribers/subscriber", locals: {thisSub: thisSub, doc: Doc.all()})
end

post("/subscribe") do 
	updateDoc = Doc.find_by(id: params["doc_id"])
	oldData = updateDoc["sub_ids"]
		if oldData == "x"
			updateDoc.update(sub_ids: params["subscriber"])
		else
			newData = oldData + "," + params["subscriber"]
			updateDoc.update(sub_ids: newData)
		end
		redirect "/documents/#{params["doc_id"]}"
end

put("/subscribers/:id") do 
	updateSub = Subscriber.find_by(id: params["id"])
	updateSub.update(
		name: params["name"],
		email: params["email"],
		phone: params["phone"]
		)
	redirect "/subscribers"
end

get("/documents/new") do
	erb(:"documents/new", locals: {doc: Doc.all(), authors: Author.all()})
end

post("/documents") do 
	content = params["content"]
	content = Markdown.new( content ).to_html
	newDoc = {
		title: params["title"],
		content: content,
		author_id: params["author_id"],
		story_date: params["story_date"],
		sub_ids: "x",
		edit: " "
	}
	Doc.create(newDoc)

	redirect "/documents/#{Doc.last['id']}"
end

get("/documents/edit/:id") do
	thisDoc = Doc.find_by(id: params[:id])
	erb(:"documents/edit", locals: {doc: Doc.all(), thisDoc: thisDoc, authors: Author.all()})
end

put("/documents/:id") do 
	updateDoc = Doc.find_by(id: params[:id])
	content = params["content"]
	content = Markdown.new(content).to_html
	oldDocContent = "On " + updateDoc["story_date"].to_s + " the following happened: " + updateDoc["content"]
	newEdit = updateDoc["edit"] + "</br>" + oldDocContent + " // Edited by " + params["editor"]
	updateDoc.update(
		title: params["title"],
		content: content, 
		story_date: params["story_date"],
		edit: newEdit
		)
	redirect "/documents/#{params[:id]}"
end

delete("/documents/edit/:id") do
	deleteDoc = Doc.find_by(id: params[:id])
	deleteDoc.delete
	redirect "/"
end

get("/documents/:id") do
	thisDoc = Doc.find_by(id: params[:id])
	erb(:"documents/doc", locals: {doc: Doc.all(), thisDoc: thisDoc, subscribers: Subscriber.all()})
end

get("/documents/#{Doc.first['id']}") do
	erb(:"documents/doc", locals: {doc: Doc.all()})
end

get("/documents/#{Doc.last['id']}") do 
	erb(:"documents/doc", locals: {doc: Doc.all()})
end	

# get("/search") do 
# 	results = Doc.select(title: params["search"])
# 	binding.pry
# 	erb(:results, locals: {results: results, doc: Doc.all()})
# end