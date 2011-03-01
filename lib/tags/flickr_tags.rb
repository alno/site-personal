require 'yaml'
require 'net/http'
require 'xml_magic'

module FlickrTags

  include Rayo::Taggable

  ENDPOINT = "http://api.flickr.com/services/rest/"

  tag 'flickr' do |tag|
    config = YAML.load File.open( File.join( File.dirname(__FILE__), '..', '..', 'config', 'flickr.yml' ) )

    tag.locals.flickr_key = config['key']
    tag.expand
  end

  tag 'flickr:photoset' do |tag|
    url = "#{ENDPOINT}?method=flickr.photosets.getPhotos&api_key=#{tag.locals.flickr_key}&photoset_id=#{tag.attr['id']}"
    rsp = ::CommonThread::XML::XmlMagic.new( Net::HTTP.get(URI.parse(url)) )

    tag.locals.photos = rsp.photoset.photo

    tag.expand
  end

  tag 'flickr:each' do |tag|
    result = ''

    tag.locals.photos.each do |photo|
      tag.locals.photo = photo
      result << tag.expand
    end

    result
  end

  tag 'flickr:url' do |tag|
    photo = tag.locals.photo

    size = if tag.attr['size']
      "_#{tag.attr['size']}"
    else
      ''
    end

    "http://farm#{photo[:farm]}.static.flickr.com/#{photo[:server]}/#{photo[:id]}_#{photo[:secret]}#{size}.jpg"
  end

  tag 'flickr:title' do |tag|
    tag.locals.photo[:title]
  end

end
