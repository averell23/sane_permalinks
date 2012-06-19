# encoding: utf-8
require 'stringex'

module SanePermalinks

  def sanitize_param(param)
    return nil unless param
    param.gsub(/[$…]*/, '').to_url
  end

end