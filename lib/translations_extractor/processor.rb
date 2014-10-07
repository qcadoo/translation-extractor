module TranslationsExtractor
  class Processor

    attr_reader :translations

    def initialize
      @translations = TranslationsExtractor::Translations.new
    end

    # Recognizes translatable Java properties files and JavaScript sources.
    # Throws :not_recognized when file could not be recognized.
    def recognize_file_type file_path
      file_name = File.basename file_path

      match = REX_LOCALE_FILE.match(File.basename file_path)

      throw :not_recognized unless match

      locale = match[:locale].to_sym

      case match[:extension]
      when "properties" then type = :properties
      when "js", "javascript" then type = :ext
      end

      [locale, type]
    end

    # Reads properties file and adds new translations.
    def read_properties locale, file_path
      JavaProperties.load(file_path).each do |key, value|
        translations.add locale, key, value
      end
    end

    # Dumps all the translations in given locale to properties file.
    def write_properties locale, file_path
      translations_in_locale = translations.map do |k,entry|
        [k, (entry.send locale)]
      end
      JavaProperties.write translations_in_locale, file_path
    end

    # Parses JS source and adds any found translations to database.
    def read_ext locale, file_path
      source = File.read file_path
      parser = TranslationsExtractor::Parser::ExtReader.new source
      parser.locale = locale
      parser.translations = translations
      parser.parse
    end

    # Parses JS source and updates it with new translations.
    def write_ext locale, file_path
      source = File.read file_path
      parser = TranslationsExtractor::Parser::ExtWriter.new source
      parser.locale = locale
      parser.translations = translations
      parser.parse
      File.write file_path, parser.result
    end

    # Reads translations from CSV.  Makes expectations on header and raises
    # exceptions when not met.
    def read_csv file_path
      csv = CSV.read file_path, headers: :first_row
      csv.headers == CSV_IMPORT_HEADER or raise "CSV header mismatch"
      csv.each do |row|
        translations.add :pl, row[0], row[3]
        translations.add :en, row[0], row[4]
      end
    end

    # Dumps translations to CSV file.
    def write_csv file_path
      csv = CSV.open file_path, "wb"
      csv << CSV_EXPORT_HEADER
      translations.each do |key, value|
        csv << [key, value.pl || "", value.en || ""]
      end
    ensure
      csv && csv.close
    end

  end
end
