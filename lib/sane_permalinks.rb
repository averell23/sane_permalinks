module SanePermalinks

  class WrongPermalink < Exception ; end

  module ClassMethods

    def permalink_options
      @permalink_options
    end

    def make_permalink(options)
      @permalink_options = options
    end

  end

  def permalink_options
    self.class.permalink_options || {}
  end

  def find_by_param(*args)
    if(permalink_options.empty? || permalink_options[:prepend_id])
      args[0] = args.first.to_i
      result = find_by_id(*args)
      raise WrongPermalink if(permalink_options[:raise_on_wrong_permalink] && result.to_param != args.first)
      result
    else
      send(:"find_by_#{permalink_options[:with].to_s}", *args)
    end
  end

  def find_by_param!(*args)
    self.find_by_param(*args) or raise ActiveRecord::RecordNotFound, "Couldn't find #{permalink_options[:with]} with permalink=#{args.first}"
  end

  def to_param
    if(!permalink_options.empty? && !permalink_options[:prepend_id])
      self.send(permalink_options[:with])
    elsif(!permalink_options.empty?)
      "#{super}-#{self.send(permalink_options[:with])}"
    else
      super
    end
  end

end