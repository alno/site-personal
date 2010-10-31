module ImagesTags

  include Rayo::Taggable

  tag 'images' do |tag|
    if tag.locals.images = tag.locals.page.context['images']
      tag.expand
    else
      ''
    end
  end

  tag 'images:count' do |tag|
    tag.locals.images.size
  end

  tag 'images:first' do |tag|
    if first = tag.locals.images.first
      tag.locals.image = first
      tag.expand
    end
  end

  tag 'images:last' do |tag|
    if first = tag.locals.images.last
      tag.locals.image = first
      tag.expand
    end
  end

  tag 'images:each' do |tag|
    result = ''

    images = tag.locals.images
    images.each_with_index do |image, i|
      tag.locals.image = image
      tag.locals.first_image = i == 0
      tag.locals.last_image = i == images.length - 1
      result << tag.expand
    end

    result
  end

  tag 'images:url' do |tag|
    "/images/#{tag.locals.image}"
  end

  tag 'images:thumbnail_url' do |tag|
    "/images/#{thumbnail tag.locals.image}"
  end

  private

  def thumbnail( img )
    ext = File.extname( img )
    img.gsub( ext, '_thumbnail' + ext )
  end

end
