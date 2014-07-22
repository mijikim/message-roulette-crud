require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments INNER JOIN messages ON comments.message_id = messages.id")

    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/edit/:id" do
    message_array = @database_connection.sql("select message from messages where id = #{params[:id]}")
    message = message_array[0]["message"]
    erb :edit, :locals => {:messages => message, :msg_id => params[:id]}
  end

  patch "/messages/edit/:id" do
    if params[:message_edited].length <= 140
      @database_connection.sql("update messages set message = '#{params[:message_edited]}' where id=#{params[:id]}")
      redirect "/"
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/messages/edit/#{params[:id]}"
    end
  end

  delete "/messages/delete/:id" do
    @database_connection.sql("DELETE FROM messages where id = #{params[:id]}")
    redirect back
  end

  post "/messages/comment/:id" do
    @database_connection.sql("INSERT INTO comments (message_id, comments) VALUES (#{params[:id]}, '#{params[:comment]}' )")
    redirect "/"
  end

end