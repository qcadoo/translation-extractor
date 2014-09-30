module Localizer
  class Processor

    Translation = Struct.new :pl, :en

    attr_reader :translations

    def initialize
      @translations = Hash.new
    end

    def add_translation locale, key, value
      entry = translations[key] ||= Translation.new
      entry[locale] = value
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
        add_translation locale, key, value
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
      parser.parse
    end

    def read_csv file_path
      CSV.foreach file_path, headers: :first_row do |row|
        add_translation :pl, row[0], row[1]
        add_translation :en, row[0], row[2]
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
