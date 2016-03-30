require "yaml"
require "../backend/hash"

module I18n
  module Backend
    class YAML < Hash
      # constructor
      def initialize(folder : String)
        super()

        # check if is a valid folder
        if (!Dir.exists?(folder))
          raise ArgumentError.new("invalid folder: #{folder}")
        end

        @_folder = (folder[-1] == "/") ? folder[0..-2] : folder

        self.load

        return self
      end

      # load translations files
      def load
        data = ::Hash(String, ::YAML::Type).new
        files = Dir.glob("#{@_folder}/*.yml")
        files.each do |file|
          lang = File.basename(file, ".yml")
          # lang = file.match(/\/([^\/]*)\.\w*$/i) as Regex::MatchData
          lang_data = ::YAML.parse(File.read(file))
          data[lang] = lang_data.as_h
        end

        return super(data)
      end
    end
  end

  def from_yaml_files(default_locale : String, folder : String)
    return self.new_object(default_locale, Backend::YAML.new(folder))
  end
end
