module Localizer::Parser::Reader

  # Handle setter in JS source.  Adds parameter to translations.
  def setter prefix, ident, text
    key = join_keys prefix, translate_setter_to_key(ident)
    translations.add locale, key, text
  end

  # Produces parser output.  Irrelevant for Reader as it relies on modifying
  # state. (Which is generally very wrong in PEGs but all modifications are
  # guarded with conditions which could be "cut" operations in other languages.)
  def output lines
    nil
  end

end
