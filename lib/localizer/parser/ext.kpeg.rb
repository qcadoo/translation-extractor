require 'kpeg/compiled_parser'

class Localizer::Parser::Ext < KPeg::CompiledParser
  # :stopdoc:

  # root = lines("")
  def _root
    _tmp = apply_with_args(:_lines, "")
    set_failed_rule :_root unless _tmp
    return _tmp
  end

  # lines = line(prefix)*:lines { lines.flatten.join }
  def _lines(prefix)

    _save = self.pos
    while true # sequence
      _ary = []
      while true
        _tmp = apply_with_args(:_line, prefix)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      lines = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  lines.flatten.join ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_lines unless _tmp
    return _tmp
  end

  # line = (< relevant(prefix) > { text } | < block(prefix) > { text } | < junk > { text })
  def _line(prefix)

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = apply_with_args(:_relevant, prefix)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  text ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = apply_with_args(:_block, prefix)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  text ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = apply(:_junk)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  text ; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_line unless _tmp
    return _tmp
  end

  # relevant = (single_call(prefix) | scope(prefix))
  def _relevant(prefix)

    _save = self.pos
    while true # choice
      _tmp = apply_with_args(:_single_call, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_scope, prefix)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_relevant unless _tmp
    return _tmp
  end

  # block = OPEN lines(prefix) CLOSE
  def _block(prefix)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_OPEN)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_lines, prefix)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_CLOSE)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # scope = EXT DOT meth_of_type("scope"):ident LPAREN string:param COMMA {join_keys(prefix, param)}:new_prefix block(new_prefix) RPAREN
  def _scope(prefix)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_EXT)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DOT)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_meth_of_type, "scope")
      ident = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_LPAREN)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_string)
      param = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_COMMA)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; join_keys(prefix, param); end
      _tmp = true
      new_prefix = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_block, new_prefix)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_RPAREN)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_scope unless _tmp
    return _tmp
  end

  # single_call = THIS DOT meth_of_type("setter"):ident LPAREN string:value RPAREN {setter(prefix, ident, value)}
  def _single_call(prefix)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_THIS)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DOT)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_meth_of_type, "setter")
      ident = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_LPAREN)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_string)
      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_RPAREN)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; setter(prefix, ident, value); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_single_call unless _tmp
    return _tmp
  end

  # string = STRING:raw {make_string(raw)}
  def _string

    _save = self.pos
    while true # sequence
      _tmp = apply(:_STRING)
      raw = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; make_string(raw); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_string unless _tmp
    return _tmp
  end

  # meth_of_type = IDENTIFIER:i &{ matches_type? i, type } { i }
  def _meth_of_type(type)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_IDENTIFIER)
      i = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  matches_type? i, type ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  i ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_meth_of_type unless _tmp
    return _tmp
  end

  # junk = (SEPARATOR | JUNK_EXPR)
  def _junk

    _save = self.pos
    while true # choice
      _tmp = apply(:_SEPARATOR)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_JUNK_EXPR)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_junk unless _tmp
    return _tmp
  end

  # JUNK_EXPR = < /[^;{}]+/ > { nil }
  def _JUNK_EXPR

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[^;{}]+)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_JUNK_EXPR unless _tmp
    return _tmp
  end

  # SEPARATOR = < /\s*\;\s*/ > { nil }
  def _SEPARATOR

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\;\s*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_SEPARATOR unless _tmp
    return _tmp
  end

  # OPEN = < /\s*\{\s*/ > { nil }
  def _OPEN

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\{\s*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_OPEN unless _tmp
    return _tmp
  end

  # CLOSE = < /\s*\}\s*/ > { nil }
  def _CLOSE

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\}\s*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_CLOSE unless _tmp
    return _tmp
  end

  # LPAREN = < /\s*\(\s*/ > { nil }
  def _LPAREN

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\(\s*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_LPAREN unless _tmp
    return _tmp
  end

  # RPAREN = < /\s*\)\s*/ > { nil }
  def _RPAREN

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\)\s*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_RPAREN unless _tmp
    return _tmp
  end

  # COMMA = < /\s*\,\s*/ > { nil }
  def _COMMA

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\,\s*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  nil ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_COMMA unless _tmp
    return _tmp
  end

  # STRING = < /\'([^']|\\.)*\'|\"([^"]|\\.)*\"/ > { text }
  def _STRING

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\'([^']|\\.)*\'|\"([^"]|\\.)*\")/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_STRING unless _tmp
    return _tmp
  end

  # DOT = "."
  def _DOT
    _tmp = match_string(".")
    set_failed_rule :_DOT unless _tmp
    return _tmp
  end

  # EXT = "Ext"
  def _EXT
    _tmp = match_string("Ext")
    set_failed_rule :_EXT unless _tmp
    return _tmp
  end

  # THIS = "this"
  def _THIS
    _tmp = match_string("this")
    set_failed_rule :_THIS unless _tmp
    return _tmp
  end

  # IDENTIFIER = < /\w+/ > { text }
  def _IDENTIFIER

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\w+)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_IDENTIFIER unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:_root] = rule_info("root", "lines(\"\")")
  Rules[:_lines] = rule_info("lines", "line(prefix)*:lines { lines.flatten.join }")
  Rules[:_line] = rule_info("line", "(< relevant(prefix) > { text } | < block(prefix) > { text } | < junk > { text })")
  Rules[:_relevant] = rule_info("relevant", "(single_call(prefix) | scope(prefix))")
  Rules[:_block] = rule_info("block", "OPEN lines(prefix) CLOSE")
  Rules[:_scope] = rule_info("scope", "EXT DOT meth_of_type(\"scope\"):ident LPAREN string:param COMMA {join_keys(prefix, param)}:new_prefix block(new_prefix) RPAREN")
  Rules[:_single_call] = rule_info("single_call", "THIS DOT meth_of_type(\"setter\"):ident LPAREN string:value RPAREN {setter(prefix, ident, value)}")
  Rules[:_string] = rule_info("string", "STRING:raw {make_string(raw)}")
  Rules[:_meth_of_type] = rule_info("meth_of_type", "IDENTIFIER:i &{ matches_type? i, type } { i }")
  Rules[:_junk] = rule_info("junk", "(SEPARATOR | JUNK_EXPR)")
  Rules[:_JUNK_EXPR] = rule_info("JUNK_EXPR", "< /[^;{}]+/ > { nil }")
  Rules[:_SEPARATOR] = rule_info("SEPARATOR", "< /\\s*\\;\\s*/ > { nil }")
  Rules[:_OPEN] = rule_info("OPEN", "< /\\s*\\{\\s*/ > { nil }")
  Rules[:_CLOSE] = rule_info("CLOSE", "< /\\s*\\}\\s*/ > { nil }")
  Rules[:_LPAREN] = rule_info("LPAREN", "< /\\s*\\(\\s*/ > { nil }")
  Rules[:_RPAREN] = rule_info("RPAREN", "< /\\s*\\)\\s*/ > { nil }")
  Rules[:_COMMA] = rule_info("COMMA", "< /\\s*\\,\\s*/ > { nil }")
  Rules[:_STRING] = rule_info("STRING", "< /\\'([^']|\\\\.)*\\'|\\\"([^\"]|\\\\.)*\\\"/ > { text }")
  Rules[:_DOT] = rule_info("DOT", "\".\"")
  Rules[:_EXT] = rule_info("EXT", "\"Ext\"")
  Rules[:_THIS] = rule_info("THIS", "\"this\"")
  Rules[:_IDENTIFIER] = rule_info("IDENTIFIER", "< /\\w+/ > { text }")
  # :startdoc:
end
