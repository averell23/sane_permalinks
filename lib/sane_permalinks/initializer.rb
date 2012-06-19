module SanePermalinks

  def self.init
    ActiveRecord::Base.send(:include, SanePermalinks)
    ActiveRecord::Base.extend(SanePermalinks::ClassMethods)
    ActiveRecord::Base.send(:alias_method, :original_to_param, :to_param)
    ActiveRecord::Base.send(:alias_method, :to_param, :sane_param)
  end

end