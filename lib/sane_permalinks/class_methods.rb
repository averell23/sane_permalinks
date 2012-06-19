module SanePermalinks

  module ClassMethods

    def permalink_options
      @permalink_options || {}
    end

    def make_permalink(options)
      @permalink_options = options
    end

    def find_by_param(*args)
      if(permalink_options.empty? || permalink_options[:prepend_id])
        result = find_by_id(args.first.to_i)
        return nil unless result
        raise(WrongPermalink, "Permalink doesn't match: #{args.first} vs. #{result.to_param}") if(permalink_options[:raise_on_wrong_permalink] && result.to_param != args.first)
        result
      else
        send(:"find_by_#{permalink_options[:with].to_s}", *args)
      end
    end

    def find_by_param!(*args)
      self.find_by_param(*args) or raise ActiveRecord::RecordNotFound, "Couldn't find #{permalink_options[:with]} with permalink=#{args.first}"
    end

  end

end