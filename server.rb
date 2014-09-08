require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'markdown'
require 'twilio-ruby' 
require_relative './lib/connection'
require_relative './lib/author'
require_relative './lib/doc'
require_relative './lib/subscriber'
require_relative './lib/docsub'

#Twilio info
account_sid = 'ACee710a3746331e7bc23e2606d90c13be' 
auth_token = '52d372150241bf32add9cabdcc7948eb'
@client = Twilio::REST::Client.new account_sid, auth_token 

def notify_subscribers(document)
	doc_subs = Docsub.where({doc_id: document.id})
	account_sid = 'ACee710a3746331e7bc23e2606d90c13be' 
auth_token = '52d372150241bf32add9cabdcc7948eb'
@client = Twilio::REST::Client.new account_sid, auth_token 
	doc_subs.each do |doc_sub|
		subscriber = Subscriber.find_by(id: doc_sub.sub_id)
		@client.account.messages.create({
			:from => '+19738280420', 
			:to => "#{subscriber.phone}", 
			:body => "#{params["title"]} was updated; go to http://www.afdwiki.com/documents/#{document.id} to see the changes", 
		})
	end
end

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
	docsubs = Docsub.where(sub_id: params[:id])
	erb(:"subscribers/subscriber", locals: {thisSub: thisSub, docsubs: docsubs, doc: Doc.all()})
end

post("/subscribe") do 
	newSub = Subscriber.find_by(id: params["subscriber"])
	Docsub.create(
		doc_id: params["doc_id"],
		sub_id: newSub.id
		)
		redirect "/documents/#{params["doc_id"]}"
end

put("/subscribers/:id") do 
	updateSub = Subscriber.find_by(id: params["id"])
	updateSub.update(
		name: params["name"],
		email: params["email"],
		phone: params["phone"]
		)
	redirect "/subscribers/:id"
end

delete("/unsubscribe/") do 
	unsub = Docsub.find_by(doc_id: params["doc_id"], sub_id: params["sub_id"])
	unsub.delete
	redirect "/subscribers"
end

get("/documents/new") do
	erb(:"documents/new", locals: {doc: Doc.all(), authors: Author.all()})
end

post("/documents") do 
	newDoc = {
		title: params["title"],
		content: params["content"],
		author_id: params["author_id"],
		story_date: params["story_date"],
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

	notify_subscribers(updateDoc)

	oldDocContent = "On " + updateDoc["story_date"].to_s + " the following happened: " + updateDoc["content"]
	newEdit = updateDoc["edit"] + "</br>" + oldDocContent + " // Edited by " + params["editor"]
	updateDoc.update(
		title: params["title"],
		content: params["content"], 
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
	docsubs = Docsub.where(doc_id: params[:id])
	erb(:"documents/doc", locals: {doc: Doc.all(), thisDoc: thisDoc, docsubs: docsubs, subscribers: Subscriber.all()})
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