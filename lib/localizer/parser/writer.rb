module Localizer::Parser::Writer

  # Handles translation in JS source.  Returns translated parameter.
  def translate prefix, key, value
    qualified_key = join_keys prefix, key
    translated = translations[qualified_key].send locale
    value.replace_with translated
  end

  # Produces parser output.  In case of Writer, concatenates all the unchanged
  # chunks of parsed source and inserted translations.
  def output lines
    lines.flatten.lazy.map{ |x| (x.respond_to? :raw) ? x.raw : x }.reduce(:<<)
  end

end
