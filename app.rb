require "sinatra"

get "/" do
  erb :index
end

post "/" do
  "{\"id\":\"12121\",\"delete_path\":\"delete\"}"
end

delete "/delete" do
  "{\"success\":true}"
end