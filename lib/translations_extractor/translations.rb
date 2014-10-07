module TranslationsExtractor

  # Translations database.
  class Translations < Hash

    Entry = Struct.new :pl, :en

    # Adds translation in given locale to database.  Overwrites previous one.
    def add locale, key, value
      entry = self[key] ||= Entry.new
      entry[locale] = value
    end

  end
end
