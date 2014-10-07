require "localizer/version"

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

  autoload :CLI, "localizer/cli"
  autoload :Processor, "localizer/processor"
  autoload :Translations, "localizer/translations"

  module Parser
    autoload :Ext, "localizer/parser/ext.kpeg"
    autoload :Common, "localizer/parser/common"
    autoload :Reader, "localizer/parser/reader"
    autoload :Writer, "localizer/parser/writer"

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
