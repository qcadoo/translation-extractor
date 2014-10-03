module Localizer::Parser::Common

  attr_accessor :locale, :translations

  # String from JS source.  Designed for easy reading and replacing string
  # content while preserving quotation (' or ").
  ParsedString = Struct.new :raw do
    def to_s
      raw[1..-2]
    end

    def new_string_with_same_quotation str
      self.class.new "" << raw[0] << str << raw[-1]
    end
  end

  # Builds new ParsedString.  Wrapped in method to be used directly in grammar.
  def make_string raw_string
    ParsedString.new raw_string
  end

  # Guard statement for grammar. Ensures that given identifier is a name of
  # expected family of methods.
  def matches_type? identifier, type
    case type
    when "setter"
      identifier =~ /\Aset(?=[[:upper:]])/
    when "scope"
      %w[define].include? identifier
    else
      false
    end
  end

  # Strips off "set" from setter names.
  def translate_setter_to_key ident
    matches_type? ident, "setter" or return
    key = ident[3..-1]
    key[0] = key[0].downcase
    key
  end

  # Join translation keys into one.
  def join_keys *segments
    segments.select(&:present?).join(".")
  end

end
