require 'cgi'

module CodeTags
  
  include Rayo::Taggable

  tag 'code' do |tag|
    "<pre><code class=\"#{tag.attr['lang']}\">#{CGI.escapeHTML tag.expand}</code></pre>"
  end
  
end