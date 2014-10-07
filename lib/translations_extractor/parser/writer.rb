# Helper methods available in grammar; ExtWriter overrides
module TranslationsExtractor::Parser::Writer

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
    json = JSON.parse src
    json.each do |translation_json|
      qualified_key = join_keys prefix, translation_json["value"]
      if translation_entry = translations[qualified_key]
        translation_json["name"] = translation_entry.send locale
      end
    end
    prettify_json_array json, src
  end

  # Produces parser output.  In case of Writer, concatenates all the unchanged
  # chunks of parsed source and inserted translations.
  def output lines
    lines.flatten.lazy.map{ |x| (x.respond_to? :raw) ? x.raw : x }.reduce(:<<)
  end

  # Renders an array of JSON objects in a pretty way, as expected in Ext source
  # files.
  def prettify_json_array json_array, original_str
    lbrack_with_spaces = /\A\s*\[\s*/.match(original_str)[0]
    rbrack_with_spaces = /\s*\]\s*\Z/.match(original_str)[0]
    indented_new_line = /\A.*(\n\s*)/.match(original_str)[1]

    out = json_array.reduce lbrack_with_spaces do |acc, obj|
      object_str = JSON.generate obj, space: " ", object_nl: " "
      acc << "," << indented_new_line unless obj == json_array[0]
      acc << object_str
    end

    out << rbrack_with_spaces
  end

end
