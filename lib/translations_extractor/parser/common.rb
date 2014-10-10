# Helper methods available in grammar.
module TranslationsExtractor::Parser::Common

  attr_accessor :locale, :translations

  # String from JS source.  Designed for easy reading and replacing string
  # content while preserving quotation (' or ").
  ParsedString = Struct.new :raw do
    def to_s
      raw[1..-2].gsub /\\./ do |m|
        case m
        when %Q[\\'] then %Q[']
        when %Q[\\"] then %Q["]
        else m
        end
      end
    end

    # Returns new ParsedString with new content but same quotation marks.
    def replace_with str
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

    # Simple setter method,
    # as in this.setTitle('Projects')
    when "setter"
      /\Aset(?=[[:upper:]])/.match(identifier).present?

    # Introduces translation scope,
    # as in Ext.define("ads.locale.en.view.project.List", { ... })
    when "scope"
      %w[define create].include? identifier

    # First method in chained call,
    # as lookupReference in this.lookupReference('editButton').setText('Edit')
    when "finder"
      %w[lookupReference queryById].include? identifier

    # Attribute,
    # as in format: 'd-m-Y'
    when "attribute"
      not %w[override].include? identifier

    # Data compound attribute,
    # as in data: [ { "name" : "Succeed", "value": "succeed"} ]
    when "data"
      %w[data].include? identifier

    when "any"
      true
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
    segments.map(&:to_s).select(&:present?).join(".")
  end

end
