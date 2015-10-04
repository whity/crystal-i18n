require "./i18n/*"

module I18n
    extend self

    def new_object(default_locale, backend)
        return I18n.new(default_locale, backend)
    end
end
