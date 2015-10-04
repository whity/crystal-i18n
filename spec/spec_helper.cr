require "spec"
require "../src/i18n"
require "../src/i18n/backend/*"

def yaml_backend()
    return I18n::Backend::YAML.new("./spec/locales")
end

def i18n_yaml_backend()
    backend = yaml_backend
    return I18n.new_object("pt", backend)
end
