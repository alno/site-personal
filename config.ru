require 'lib/application.rb'
require 'rack/rewrite'

use Rack::Rewrite do
  rewrite '/author/en', '/en/author'
  rewrite %r{/tags/(\w+)}, '/'
end

run Application