module I18n
  class I18n
    getter :default_locale

    # setup i18n module data
    def initialize(default_locale : String, backend : Backend::Base)
      @default_locale = default_locale
      @_backend = backend

      return self
    end

    def default_locale=(value : String)
      @default_locale = value
    end

    # available locales
    def available_locales
      return @_backend.available_locales
    end

    # reload
    def reload
      @_backend.load

      return self
    end

    def translate(key, locale = @default_locale : String, count = 0 : Int)
      result = @_backend.lookup(locale, key)
      if (!result)
        return key
      end

      if (!result.is_a?(Hash))
        return result
      end

      result = result as Hash

      # ##if result is a 'hash' and we passed 'count', check for the right message to return
      if (count <= 0)
        return result.fetch("other", nil)
      end

      # all keys 'number' or 'number..number' are a range, get the first that 'count' matches
      msg = result.delete("other")
      keys = result.keys.map { |item| item.to_s }.sort
      keys.each do |key|
        value = result[key]
        match = key.match(/^\d+$/)
        if (match && count == key.to_i)
          msg = value
          break
        end

        # if not a range, continue to the next one
        match = key.match(/^(\d+)..(\d+)?$/i)
        if (!match)
          next
        end
        match = match as Regex::MatchData

        # if end isn't defined, just check if count is bigger or equal than start
        range_end = match[2]?
        if (!range_end)
          if (count >= match[1].to_i)
            msg = value
            break
          end

          next
        end

        range = Range.new(match[1].to_i, match[2].to_i)
        if (range.includes?(count))
          msg = value
          break
        end
      end

      if (msg.is_a?(String))
        return sprintf(msg, count)
      end

      return
    end

    def date(value, locale = @default_locale : String, format = "default" : String)
      formats = @_backend.date(locale)
      return self._date_time(value, locale, formats, format, :date)
    end

    def time(value, locale = @default_locale : String, format = "default" : String)
      formats = @_backend.time(locale)
      return self._date_time(value, locale, formats, format, :time)
    end

    def currency(value : String, locale = @default_locale : String)
      # convert value to string
      value = value.to_s

      # get currency definitions from backend
      currency_formats = @_backend.currency(locale)

      if (!value || value.size == 0)
        return currency_formats
      end

      # format value to number
      value = self.number(value, locale)

      # get format
      format = currency_formats.fetch("format", "") as String
      if (format.size == 0)
        return value
      end

      # buid new value
      return sprintf(format, value)
    end

    def number(value : String, locale = @default_locale : String)
      # get number definitions from backend
      nbr_formats = @_backend.number(locale)

      if (!value || value.size == 0)
        return nbr_formats
      end

      # get decimal separator
      dec_separator = nbr_formats.fetch("decimal_separator", ".") as String
      if (dec_separator)
        value = value.sub(/\./, dec_separator)
      end

      # ## set precision separator ###
      # split by decimal separator
      match = value.match(/(\d+)#{dec_separator}?(\d+)?/i)
      if (!match)
        return value
      end
      match = match as Regex::MatchData

      integer = match[1]
      decimal = match[2]?

      precision_separator = nbr_formats.fetch("precision_separator", "") as String
      new_value = ""
      counter = 0
      index = integer.size - 1
      while (index >= 0)
        if (counter >= 3)
          new_value = precision_separator + new_value
          counter = 0
        end

        new_value = integer[index].to_s + new_value

        index -= 1
        counter += 1
      end

      value = new_value
      if (decimal)
        value += dec_separator + decimal
      end
      # ##

      return value
    end

    protected def _date_time(value : Time, locale : String, formats : Hash,
                             type : String, date_or_time : Symbol)
      # get date definitions from backend
      if (value == nil)
        return formats
      end

      # get display formats
      display_formats = formats.fetch("formats", nil)
      if (!display_formats || !display_formats.is_a?(Hash))
        # TODO: display formats not defined, log it
        return value
      end
      display_formats = display_formats as Hash

      # check if type format exists
      if (!display_formats[type])
        # TODO: display format not defined, log it
        return value
      end

      # translate text value
      format = display_formats[type] as String

      # if the caller method was 'date', do the replace, otherwise ignore it
      if (date_or_time == :date)
        format = format.gsub(/%[aAbB]/) do |match|
          replace = nil
          if (match == "%a")
            abbr_day_names = formats["abbr_day_names"] as Array
            replace = abbr_day_names[value.day_of_week.to_i]
          elsif (match == "%A")
            day_names = formats["day_names"] as Array
            replace = day_names[value.day_of_week.to_i]
          elsif (match == "%b")
            abbr_month_names = formats["abbr_month_names"] as Array
            replace = abbr_month_names[value.month]
          elsif (match == "%B")
            month_names = formats["month_names"] as Array
            replace = month_names[value.month]
          end

          if (replace)
            next replace
          end

          next match
        end
      end

      return value.to_s(format)
    end
  end
end
