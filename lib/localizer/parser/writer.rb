module Localizer::Parser::Writer

  def setter prefix, ident, text
    key = join_keys prefix, translate_setter_to_key(ident)
    translated = translations[key].send locale
    text.new_string_with_same_quotation translated
  end

end
