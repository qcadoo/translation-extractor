# Helper methods available in grammar; ExtWriter overrides
module Localizer::Parser::Writer

  # Handles translation in JS source.  Returns translated parameter.
  def translate prefix, key, value
    qualified_key = join_keys prefix, key
    if translation_entry = translations[qualified_key]
      value.replace_with translation_entry.send locale
    else
      value
    end
  end

  # Handles translation of composite data attributes.
  def translate_json prefix, src
    src
  end

  # Produces parser output.  In case of Writer, concatenates all the unchanged
  # chunks of parsed source and inserted translations.
  def output lines
    lines.flatten.lazy.map{ |x| (x.respond_to? :raw) ? x.raw : x }.reduce(:<<)
  end

end
