require 'rspec'  
require 'rack/test'
require_relative '../api/v1/scrapper.rb'  

set :environment, :test

describe "Service Scrapper" do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end

  it "when doesn't has http" do
    get "/api/v1/scrapper?url=www.uol.com.br"
    expect(last_response.body).to eq '{"message":"The argument url with http or https is necessary!"}'
  end
  
  it "when has duration video " do
    get "/api/v1/scrapper?url=https://www.youtube.com/watch?v=bZL2v37uqFE"
    expect(last_response.body).to include '"duration":"PT6M38S"'
  end
  
  it "when has image file" do
    get "/api/v1/scrapper?url=https://www.youtube.com/watch?v=bZL2v37uqFE"
    expect(last_response.body).to include '"image":"https://i.ytimg.com/vi/bZL2v37uqFE/maxresdefault.jpg"'
  end
  
  it "when url socket expect" do
    get "/api/v1/scrapper?url=https://www.uol.com.fd"
    expect(last_response.body).to eq '{"message":"Page not found!"}'
  end
  
  it "about page" do
    get '/about'
    expect(last_response).to be_ok
  end
  
end