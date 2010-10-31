require '../rayo/lib/rayo.rb'

class Application < Rayo::Application

  configure do |c|
    c.content_dir = File.join( File.dirname(__FILE__), 'content' )
    c.languages = ['ru','en']
  end

  set :public, File.join( File.dirname(__FILE__), 'public' )

end
