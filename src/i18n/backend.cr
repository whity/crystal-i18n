module I18n
    module Backend
        class Base
            # lookup for the key and return the value
            def lookup(locale : String, key : String)
                raise ::I18n::Exceptions::NotImplementedError.new
            end

            # available locales
            def available_locales()
                raise ::I18n::Exceptions::NotImplementedError.new
            end

            # load locales
            def load()
                raise ::I18n::Exceptions::NotImplementedError.new
            end

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
