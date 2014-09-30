module Localizer::Parser::Reader

  def setter prefix, ident, text
    key = join_keys prefix, translate_setter_to_key(ident)
    translations.add locale, key, text
  end

end
