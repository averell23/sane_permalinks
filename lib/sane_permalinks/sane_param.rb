module SanePermalinks

  class WrongPermalink < Exception ; end

  def permalink_options
    self.class.permalink_options
  end

  def sane_param
    sanitize_param(make_param)
  end

  def make_param
    if(!permalink_options.empty? && !permalink_options[:prepend_id])
      self.send(permalink_options[:with])
    elsif(!permalink_options.empty?)
      "#{original_to_param}-#{self.send(permalink_options[:with])}"
    else
      original_to_param
    end
  end

end