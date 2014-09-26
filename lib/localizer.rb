require "localizer/version"

require "thor"

module Localizer

  # When unsure how to modify this class, check: http://whatisthor.com/
  # or: http://blog.paracode.com/2012/05/17/building-your-tools-with-thor/
  class CLI < Thor

    long_desc <<-DESC
Generates translation CSV from given Sencha Ext sources and Java properties.

EXAMPLES

  export -o translations.csv locale_*.properties
  export -o translations.csv locale-pl.js
  export -o translations.csv *
DESC
    desc "export -o TRANSLATIONS [JAVA_PROPERTIES] [EXT_SOURCES]",
      "export translations"
    option :output,
      type: :string, aliases: ["-o"],
      desc: "Translations CSV file to be (over)written."
    def export *source_paths
    end


    long_desc <<-DESC
Updates Sencha Ext sources and Java properties according to translations file.

EXAMPLES

  import -i translations.csv locale_*.properties
  import -i translations.csv locale-pl.js
  import -i translations.csv *
DESC
    desc "import -i TRANSLATIONS [JAVA_PROPERTIES] [EXT_SOURCES]",
      "import translations"
    option :input, type: :string, aliases: ["-i"],
      desc: "CSV file with translations"
    def import *source_paths
    end

  end
end
