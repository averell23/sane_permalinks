require 'stringex'

module SanePermalinks

  def sanitize_param(param)
    param.to_url.gsub(/[$]*/, '')
  end

end