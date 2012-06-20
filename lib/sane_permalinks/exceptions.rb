module SanePermalinks
    class WrongPermalink < Exception

      attr_accessor :obj

      def initialize(message, object = nil)
        super(message)
        self.obj = object
      end

    end
end