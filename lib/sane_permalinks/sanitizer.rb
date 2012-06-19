# encoding: utf-8
require 'stringex'

module SanePermalinks

  def sanitize_param(param)
    param.gsub(/[$…]*/, '').to_url
  end

end