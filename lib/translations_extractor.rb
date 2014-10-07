require "translations_extractor/version"

require "active_support/all"
require "csv"
require "java-properties"
require "json"
require "thor"

module Localizer

  REX_LOCALE_FILE =
    /\Alocale[-_](?<locale>.+)\.(?<extension>js|javascript|properties)\Z/
  CSV_EXPORT_HEADER =
    ["Klucz", "Translacja polska", "Translacja angielska"]
  CSV_IMPORT_HEADER =
    ["Klucz", "Translacja polska", "Translacja angielska",
    "Nowa translacja polska", "Nowa translacja angielska"]

  autoload :CLI, "translations_extractor/cli"
  autoload :Processor, "translations_extractor/processor"
  autoload :Translations, "translations_extractor/translations"

  module Parser
    autoload :Ext, "translations_extractor/parser/ext.kpeg"
    autoload :Common, "translations_extractor/parser/common"
    autoload :Reader, "translations_extractor/parser/reader"
    autoload :Writer, "translations_extractor/parser/writer"

    class ExtReader < Ext
      include Common
      include Reader
    end

    class ExtWriter < Ext
      include Common
      include Writer
    end
  end

end
