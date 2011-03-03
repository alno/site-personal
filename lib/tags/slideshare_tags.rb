require 'yaml'
require 'net/http'
require 'xml_magic'
require 'digest/sha1'

module SlideshareTags

  include Rayo::Taggable

  ENDPOINT = "http://www.slideshare.net/api/2/"
  
  tag 'slideshare' do |tag|
    config = YAML.load File.open( File.join( File.dirname(__FILE__), '..', '..', 'config', 'slideshare.yml' ) )

    tag.locals.slideshare_key = config['key']
    tag.locals.slideshare_secret = config['secret']
    tag.expand
  end
  
  def gen_slideshare_token tag
    ts = Time.now.to_i
    hash = Digest::SHA1.hexdigest(tag.locals.slideshare_secret + ts.to_s)

    "api_key=#{tag.locals.slideshare_key}&ts=#{ts}&hash=#{hash}"
  end

  tag 'slideshare:slideshows' do |tag|
    url = "#{ENDPOINT}get_slideshows_by_user?username_for=#{tag.attr['user']}&#{gen_slideshare_token tag}"
    rsp = ::CommonThread::XML::XmlMagic.new( Net::HTTP.get(URI.parse(url)) )

    tag.locals.slideshows = rsp.Slideshow

    tag.expand
  end

  tag 'slideshare:each' do |tag|
    result = ''

    tag.locals.slideshows.each do |slideshow|
      tag.locals.slideshow = slideshow
      result << tag.expand
    end

    result
  end

  tag 'slideshare:title' do |tag|
    tag.locals.slideshow.Title.to_s
  end

  tag 'slideshare:description' do |tag|
    tag.locals.slideshow.Description.to_s
  end

  tag 'slideshare:embed' do |tag|
    tag.locals.slideshow.Embed.to_s.gsub /<div style="padding:5px 0 12px">View more .*\.<\/div>/, ''
  end
  
  tag 'slideshare:download_url' do |tag|
    tag.locals.slideshow.DownloadUrl.to_s
  end
  
  tag 'slideshare:thumbnail_url' do |tag|
    tag.locals.slideshow.ThumbnailUrl.to_s
  end

end
