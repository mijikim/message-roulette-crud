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

    erb :home, locals: {messages: messages}
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

  get "/messages/edit/:message" do
    message_id = params[:message]
    message_id[0] = ''
    message_array = @database_connection.sql("select message from messages where id = #{message_id}")
    message = message_array[0]["message"]
    erb :edit, :locals => {:messages => message, :msg_id => message_id}
  end

  patch "/messages/edit/:message" do
    message_id = params[:message]
    message_id[0] = ''
    @database_connection.sql("update messages set message = '#{params[:message_edited]}' where id=#{message_id}")
    redirect "/"
  end

end