# Helper methods available in grammar; ExtReader overrides
module TranslationsExtractor::Parser::Reader

  # Adds parameter to translations.
  def translate prefix, key, text
    qualified_key = join_keys prefix, key
    translations.add locale, qualified_key, text
  end

  # Handles translation of composite data attributes.
  def translate_json prefix, src
    json = JSON.parse src
    json.each do |translation_json|
      qualified_key = join_keys prefix, translation_json["value"]
      translations.add locale, qualified_key, translation_json["name"]
    end
  end

  # Produces parser output.  Irrelevant for Reader as it relies on modifying
  # state. (Which is generally very wrong in PEGs but all modifications are
  # guarded with conditions which could be "cut" operations in other languages.)
  def output lines
    nil
  end

end
