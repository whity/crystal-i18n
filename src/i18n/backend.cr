module I18n
  module Backend
    abstract class Base
      # lookup for the key and return the value
      abstract def lookup(locale : String, key : String)

      # available locales
      abstract def available_locales

      # load locales
      abstract def load

      # return number formats
      def number(locale : String)
        hash = self.lookup(locale, "__formats__.number")
        return self._ensure_hash(hash)
      end

      # return currency formats
      def currency(locale : String)
        hash = self.lookup(locale, "__formats__.currency")
        return self._ensure_hash(hash)
      end

      # return date formats
      def date(locale : String)
        hash = self.lookup(locale, "__formats__.date")
        return self._ensure_hash(hash)
      end

      # return time formats
      def time(locale : String)
        hash = self.lookup(locale, "__formats__.time")
        return self._ensure_hash(hash)
      end

      # ensure hash
      protected def _ensure_hash(hash)
        if (!hash.is_a?(::Hash))
          hash = ::Hash(String, String).new
        end

        return hash as ::Hash
      end
    end
  end
end
