require "localizer/version"

require "csv"
require "java-properties"
require "thor"

module Localizer

  REX_LOCALE_FILE = /\Alocale[-_](?<locale>.+)\.(?<extension>js|javascript|properties)\Z/
  CSV_EXPORT_HEADER = ["Klucz", "Translacja polska", "Translacja angielska"]

  autoload :CLI, "localizer/cli"
  autoload :Processor, "localizer/processor"

end
