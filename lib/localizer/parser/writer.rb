module Localizer::Parser::Writer

  def setter prefix, ident, text
    key = join_keys prefix, translate_setter_to_key(ident)
    translated = translations[key].send locale
    text.new_string_with_same_quotation translated
  end

  # Produces parser output.  In case of Writer, concatenates all the unchanged
  # chunks of parsed source and inserted translations.
  def output lines
    lines.flatten.lazy.map{ |x| (x.respond_to? :raw) ? x.raw : x }.reduce(:<<)
  end

end
