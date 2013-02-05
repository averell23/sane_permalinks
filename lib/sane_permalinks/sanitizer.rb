# encoding: utf-8

require 'active_support/core_ext/string/inflections'

module SanePermalinks

  def sanitize_param(param)
    return nil unless param
    param.gsub(/[$…»«]/, '').parameterize # The gsub throws out some stuff we don't trust stringex with... ;-)
  end

end
