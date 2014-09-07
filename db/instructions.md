## Wiki

---

A wiki is an application that allows users to create and modify content collaboratively. In a wiki application, the history of a document and changes to it are an important part of what they are. Wikis can chart and connect content from a variety of sources, and the interaction of users working on them. The most popular example is Wikipedia ([sample page](http://en.wikipedia.org/wiki/Gorham%27s_Cave)) but Github also comes with a nice wiki ([sample page](https://github.com/Netflix/Hystrix/wiki)).</span>

###***MVP***

- **Data model**:
  - `document`
  - `subscriber`
  - `author`
- **Required technologies or features**:
  - [Twilio](https://www.twilio.com/docs/api)
    - Allows an application to send text messages to any phone number
  - [SendGrid](https://sendgrid.com/docs/index.html)
    - Allows an application to send emails
- **Examples Ideas**:
  - collaborative wdi cheatsheets,
  - a wiki for your favorite tv show, movie, book series, etc.
- **User Stories (MVP)**:
  - A user can create a wiki document
  - A user can specify an author when creating a wiki document by either creating a new author or choosing a pre-existing one from a drop-down menu
  - A user can edit a wiki document (this does not change the original author of the wiki document)
  - A user can delete a wiki document
  - A user can view an author's page that lists the pages that they have created or edited
  - A wiki document should always be written using markdown format
  - A user can search for wikis by title (only exact matches need to be supported)
  - A user can link to other pages in the wiki by using the syntax [[document-title]]
  - A user can subscribe to a document and receive an email or text message when this document is modified (using Twilio/Sendgrid)
    - This text message or email should at least contain the title of the document 
  - A user can see a history of changes for a document

###***Bonus***

- **Additional Data models**
  - `comment`
- **Further User Stories**:
  - A user can add comments to a wiki page on a "discuss" page used to discuss changes to a wiki document
  - A user can see on the front page all recent activity done to the wiki (creations/edits/deletions)
  - A user can perform a full text search, meaning that searching for "unicorn" will not only bring up the document with the title "unicorn" but also any wiki document that has the word unicorn in it
  - A user can revert a wiki document to a previous revision
  - **Super Bonus** A user can see all wiki documents that reference a given document using the syntax [[document-title]]
  - **Super Bonus** Allow the user to be able to see a visual "diff" between two different versions of a document in its edit history (this would be very hard to do without using an external library of some sort)
- **Incorporate Bundler and a Gemfile into your application**
  - [Bundler Website](http://bundler.io/)
  - [Why use Bundler?](http://bundler.io/rationale.html)
  - [What is a Gemfile?](http://bundler.io/v1.3/gemfile.html)
  - [Sinatra docs for Bundler and Gemfiles](http://recipes.sinatrarb.com/p/development/bundler)
- **JSON Activity Streams and/or Request Response**
  - [Activity Streams](http://en.wikipedia.org/wiki/Activity_Streams_(format)) are complex feeds that explain what is happening on your site. Your AS feed would be served from the endpoint `/as` and would record all the editing activity on the wiki. This sort of feed could be generated using a gem, [for example](https://github.com/nov/activitystreams)
  - Alternatively, you can offer up a JSON representation of a single wiki document at the endpoint `/as/post-id` -- a much simpler option.
  - Or you can do both!
  - To get Sinatra to form responses in JSON format rather than HTML, check out this [tutorial](http://nathanhoad.net/how-to-return-json-from-sinatra)
- **Implement responsive web design to your application**
  - [What the heck is responsive web design?](http://johnpolacek.github.io/scrolldeck.js/decks/responsive/)

  [how to write in markdown](https://help.github.com/articles/markdown-basics)