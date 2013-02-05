# encoding: utf-8

require 'active_support/core_ext/string/inflections'

module SanePermalinks

  def sanitize_param(param)
    param or return
    param.parameterize
  end

end
