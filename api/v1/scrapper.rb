require 'sinatra'
require 'json'
require 'open-uri'
require 'nokogiri'

set :show_exceptions, false

get '/api/v1/scrapper' do
    content_type :json
  
    begin
        unless params[:url].nil?
            unless (params[:url].include? 'http')
                status 500
                { :message => 'The argument url with http or https is necessary!' }.to_json
            else
                doc = Nokogiri::HTML(open(params[:url]))
                {   :message => 'Site found!', 
                    :title => doc.at("title").text,
                    :description =>doc.at("meta[name='description']").nil? ? '' : doc.at("meta[name='description']")["content"],
                    :image => doc.at("meta[property='og:image']").nil? && doc.at("meta[property='twitter:image']").nil? ? '' : (doc.at("meta[property='og:image']")["content"] || doc.at("meta[property='twitter:image']")["content"]),
                    :video => doc.at("meta[property='og:video:url']").nil? ? '' : doc.at("meta[property='og:video:url']")["content"],
                    :duration => doc.at('meta[itemprop="duration"]').nil? ? '' : doc.at('meta[itemprop="duration"]')['content'] # From Youtube
                }.to_json
            end
        else
            status 500
            { :message => 'The argument url is necessary!' }.to_json
        end

    rescue Exception
        { :message => 'Page not found!' }.to_json
    end
end

get '/about' do
    "Little about me! <br/>Scrapper with Nokogiri, Sinatra, Puma, Foreman"
end