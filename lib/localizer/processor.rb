module Localizer
  class Processor

    attr_reader :translations

    def initialize
      @translations = Localizer::Translations.new
    end

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

    def read_properties locale, file_path
      JavaProperties.load(file_path).each do |key, value|
        translations.add locale, key, value
      end
    end

    def write_properties locale, file_path
      translations_in_locale = translations.map do |k,entry|
        [k, (entry.send locale)]
      end
      JavaProperties.write translations_in_locale, file_path
    end

    def read_ext locale, file_path
      source = File.read file_path
      parser = Localizer::Parser::ExtReader.new source
      parser.locale = locale
      parser.translations = translations
      parser.parse
    end

    def write_ext locale, file_path
      source = File.read file_path
      parser = Localizer::Parser::ExtWriter.new source
      parser.locale = locale
      parser.translations = translations
      parser.parse
      File.write file_path, parser.result
    end

    def read_csv file_path
      csv = CSV.read file_path, headers: :first_row
      csv.headers == CSV_IMPORT_HEADER or raise "CSV header mismatch"
      csv.each do |row|
        translations.add :pl, row[0], row[3]
        translations.add :en, row[0], row[4]
      end
    end

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
