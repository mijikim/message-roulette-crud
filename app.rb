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
    comments = @database_connection.sql("SELECT * FROM comments")

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

  get "/messages/view/:id" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments")
    erb :messages, :locals => {:messages => messages, :comments => comments, :msg_id => params[:id]}
  end

  patch "/messages/likes/:id" do
    likes = @database_connection.sql("SELECT likes from messages where id=#{params[:id]}")
    likes_num = 1
    if likes[0]["likes"] == nil
      likes_num
    else
      likes_num = likes[0]["likes"].to_i + 1
    end
    @database_connection.sql("update messages set likes = #{likes_num} where id=#{params[:id]}")
  redirect back
  end

  patch "/messages/unlikes/:id" do
    likes = @database_connection.sql("SELECT likes from messages where id=#{params[:id]}")
    likes_num = 0
    if likes[0]["likes"] == nil || likes[0]["likes"] == "0"
      likes_num
    else
      likes_num = likes[0]["likes"].to_i - 1
    end
    @database_connection.sql("update messages set likes = #{likes_num} where id=#{params[:id]}")
    redirect back
  end

end