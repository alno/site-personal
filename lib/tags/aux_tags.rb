require 'cgi'

module AuxTags

  include Rayo::Taggable

  tag 'code' do |tag|
    "<pre><code class=\"#{tag.attr['lang']}\">#{CGI.escapeHTML tag.expand}</code></pre>"
  end

  tag 'month' do |tag|
    case tag.globals.page.lang
      when 'ru' then [ 'Неизвестно', 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь' ]
      else [ 'Unknown', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ]
    end[ tag.expand.to_i ]
  end

end
