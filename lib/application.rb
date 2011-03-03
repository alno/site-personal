require '../rayo/lib/rayo'

require 'lib/tags/images_tags.rb'
require 'lib/tags/aux_tags.rb'
require 'lib/tags/flickr_tags.rb'
require 'lib/tags/slideshare_tags.rb'

require 'redcloth'

class Application < Rayo::Application

  configure do |c|
    c.content_dir = File.join( File.dirname(__FILE__), '..', 'content' )
    c.cache_dir = File.join( File.dirname(__FILE__), '..', 'cache' )
    c.languages = ['ru','en']

    c.add_filter 'textile' do |source|
      RedCloth.new( source ).to_html
    end

    c.add_tags AuxTags
    c.add_tags ImagesTags
    c.add_tags FlickrTags
    c.add_tags SlideshareTags

    c.add_domain 'alno.name', /^(local\.|www\.)?alno\.name$/
    c.add_domain 'blog.alno.name', /^(local\.|www\.)?blog\.alno\.name$/
    c.add_domain 'degu.alno.name', /^(local\.|www\.)?degu\.alno\.name$/

    c.default_domain = 'alno.name'
  end

  set :public, File.join( File.dirname(__FILE__), '..', 'public' )

end
