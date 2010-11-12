require '../rayo/lib/rayo.rb'

require 'lib/tags/images_tags.rb'
require 'lib/tags/code_tags.rb'

require 'redcloth'

class Application < Rayo::Application

  configure do |c|
    c.content_dir = File.join( File.dirname(__FILE__), '..', 'content' )
    c.languages = ['ru','en']

    c.add_filter 'textile' do |source|
      RedCloth.new( source ).to_html
    end

    c.add_tags CodeTags
    c.add_tags ImagesTags

    c.add_domain 'alno.name', /^(www\.)?alno\.name$/
    c.add_domain 'blog.alno.name', /^(www.)?blog\.alno\.name$/

    c.default_domain = 'blog.alno.name'
  end

  set :public, File.join( File.dirname(__FILE__), '..', 'public' )

end
