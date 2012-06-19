# encoding: utf-8
require 'stringex'

module SanePermalinks

  def sanitize_param(param)
    return nil unless param
    param.gsub(/[$…»«]/, '').to_url # The gsub throws out some stuff we don't trust stringex with... ;-)
  end

end