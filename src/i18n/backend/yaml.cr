require "yaml"
require "../backend/hash"


module I18n
    module Backend
        class YAML < Hash
            #constructor
            def initialize(folder : String)
                super()

                # check if is a valid folder
                if (!Dir.exists?(folder))
                    raise ArgumentError.new("invalid folder: #{ folder }")
                end

                @_folder = (folder[-1] == "/") ? folder[0 .. -2] : folder

                self.load

                return self
            end

            # load translations files
            def load()
                data = ::Hash(String, ::YAML::Type).new
                files = Dir.glob("#{ @_folder }/*.yml")
                files.each do |file|
                    lang = file.match(/\/([^\/]*)\.\w*$/i) as Regex::MatchData
                    lang_data = ::YAML.load(File.open(file).read)
                    data[lang[1]] = lang_data
                end

                return super(data)
            end
        end
    end
end
