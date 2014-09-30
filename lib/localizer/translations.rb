module Localizer
  class Translations < Hash

    Entry = Struct.new :pl, :en

    def add locale, key, value
      entry = self[key] ||= Entry.new
      entry[locale] = value
    end

  end
end
