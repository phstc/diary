require "sinatra"
require "sinatra/assetpack"

class Calendar < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  assets do
    js :app, [ "/js/jquery.js", "/js/d3.js", "/js/*.js" ]
    css :app, [ "/css/*.css"]
  end


  get "/:username" do
    erb :calendar
  end
end
