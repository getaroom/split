require "json"

module Split
  module Persistence
    class CookieAdapter

      EXPIRES = Time.now + 31536000 # One year from now
      DEFAULT_CONFIG = { :expires => EXPIRES }.freeze

      def initialize(context)
        @cookies = context.send(:cookies)
      end

      def [](key)
        hash[key]
      end

      def []=(key, value)
        set_cookie(hash.merge(key => value))
      end

      def delete(key)
        set_cookie(hash.tap { |h| h.delete(key) })
      end

      def keys
        hash.keys
      end

      def self.with_config(options = {})
        self.config.merge!(options)
        self
      end

      def self.config
        @config ||= DEFAULT_CONFIG.dup
      end

      private

      def set_cookie(value)
        @cookies[:split] = { :value => JSON.generate(value) }.merge(self.class.config)
      end

      def hash
        if @cookies[:split]
          begin
            JSON.parse(@cookies[:split])
          rescue JSON::ParserError
            {}
          end
        else
          {}
        end
      end

    end
  end
end
