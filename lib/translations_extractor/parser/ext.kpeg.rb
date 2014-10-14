require 'kpeg/compiled_parser'

class TranslationsExtractor::Parser::Ext < KPeg::CompiledParser
  # :stopdoc:

  # root = lines("")
  def _root
    _tmp = apply_with_args(:_lines, "")
    set_failed_rule :_root unless _tmp
    return _tmp
  end

  # lines = line(prefix)*:lines {output(lines)}
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
      @result = begin; output(lines); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_lines unless _tmp
    return _tmp
  end

  # line = (relevant(prefix) | block(prefix) | < junk > { text })
  def _line(prefix)

    _save = self.pos
    while true # choice
      _tmp = apply_with_args(:_relevant, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_block, prefix)
      break if _tmp
      self.pos = _save

      _save1 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = apply(:_junk)
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
      break
    end # end choice

    set_failed_rule :_line unless _tmp
    return _tmp
  end

  # relevant = (prefix_override | data_definition(prefix) | attribute(prefix) | single_call(prefix) | chained_call(prefix) | chained_with_assignment(prefix) | ads_call(prefix) | scope(prefix))
  def _relevant(prefix)

    _save = self.pos
    while true # choice
      _tmp = apply(:_prefix_override)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_data_definition, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_attribute, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_single_call, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_chained_call, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_chained_with_assignment, prefix)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_ads_call, prefix)
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

  # block = OPEN:op lines(prefix):li CLOSE:cl { [op, li, cl] }
  def _block(prefix)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_OPEN)
      op = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_lines, prefix)
      li = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_CLOSE)
      cl = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [op, li, cl] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # scope = < EXT DOT meth_of_type("scope"):ident LPAREN STRING:param COMMA > {join_keys(prefix, param)}:new_prefix block(new_prefix):lines_src RPAREN:right_src { [text, lines_src, right_src] }
  def _scope(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_EXT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "scope")
        ident = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_LPAREN)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_STRING)
        param = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_COMMA)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
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
      lines_src = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_RPAREN)
      right_src = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, lines_src, right_src] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_scope unless _tmp
    return _tmp
  end

  # single_call = < THIS DOT meth_of_type("setter"):ident LPAREN > STRING:value RPAREN:right_src {translate_setter_to_key(ident)}:key {translate(prefix, key, value)}:translated_value { [text, translated_value, right_src] }
  def _single_call(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_THIS)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "setter")
        ident = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_LPAREN)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_STRING)
      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_RPAREN)
      right_src = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate_setter_to_key(ident); end
      _tmp = true
      key = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate(prefix, key, value); end
      _tmp = true
      translated_value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, translated_value, right_src] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_single_call unless _tmp
    return _tmp
  end

  # chained_call = < THIS DOT meth_of_type("finder"):ident LPAREN STRING:key RPAREN:right_src DOT meth_of_type("any") LPAREN > STRING:value RPAREN:right_src {translate(prefix, key, value)}:translated_value { [text, translated_value, right_src] }
  def _chained_call(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_THIS)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "finder")
        ident = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_LPAREN)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_STRING)
        key = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_RPAREN)
        right_src = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "any")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_LPAREN)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_STRING)
      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_RPAREN)
      right_src = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate(prefix, key, value); end
      _tmp = true
      translated_value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, translated_value, right_src] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_chained_call unless _tmp
    return _tmp
  end

  # chained_with_assignment = < THIS DOT meth_of_type("finder"):ident LPAREN STRING:key RPAREN:right_src DOT meth_of_type("any") ASSIGN > STRING:value {translate(prefix, key, value)}:translated_value { [text, translated_value] }
  def _chained_with_assignment(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_THIS)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "finder")
        ident = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_LPAREN)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_STRING)
        key = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_RPAREN)
        right_src = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "any")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ASSIGN)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_STRING)
      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate(prefix, key, value); end
      _tmp = true
      translated_value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, translated_value] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_chained_with_assignment unless _tmp
    return _tmp
  end

  # ads_call = < "ads" DOT "app" DOT meth_of_type("any") LPAREN STRING:key1 RPAREN DOT meth_of_type("any"):key2 ASSIGN > STRING:value {join_keys(key1, key2)}:key {translate(prefix, key, value)}:translated_value { [text, translated_value] }
  def _ads_call(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("ads")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("app")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "any")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_LPAREN)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_STRING)
        key1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_RPAREN)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_DOT)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_meth_of_type, "any")
        key2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_ASSIGN)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_STRING)
      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; join_keys(key1, key2); end
      _tmp = true
      key = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate(prefix, key, value); end
      _tmp = true
      translated_value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, translated_value] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ads_call unless _tmp
    return _tmp
  end

  # attribute = < meth_of_type("attribute"):key COLON > STRING:value COMMA:right_src {translate(prefix, key, value)}:translated_value { [text, translated_value, right_src] }
  def _attribute(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply_with_args(:_meth_of_type, "attribute")
        key = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_COLON)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_STRING)
      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_COMMA)
      right_src = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate(prefix, key, value); end
      _tmp = true
      translated_value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, translated_value, right_src] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_attribute unless _tmp
    return _tmp
  end

  # data_definition = < meth_of_type("data"):data COLON > json(prefix):json { [text, json] }
  def _data_definition(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply_with_args(:_meth_of_type, "data")
        data = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_COLON)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_json, prefix)
      json = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, json] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_data_definition unless _tmp
    return _tmp
  end

  # prefix_override = < "override" COLON STRING:new_prefix > lines(new_prefix):li { [text, li] }
  def _prefix_override

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("override")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_COLON)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_STRING)
        new_prefix = @result
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_lines, new_prefix)
      li = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [text, li] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_prefix_override unless _tmp
    return _tmp
  end

  # json = < json_part > {translate_json(prefix, text)}:translated_json { translated_json }
  def _json(prefix)

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = apply(:_json_part)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; translate_json(prefix, text); end
      _tmp = true
      translated_json = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  translated_json ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_json unless _tmp
    return _tmp
  end

  # json_part = (OPEN ((json_attr COMMA)* json_attr)? CLOSE | LBRACK ((json_part COMMA)* json_part)? RBRACK | STRING)
  def _json_part

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_OPEN)
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos

        _save3 = self.pos
        while true # sequence
          while true

            _save5 = self.pos
            while true # sequence
              _tmp = apply(:_json_attr)
              unless _tmp
                self.pos = _save5
                break
              end
              _tmp = apply(:_COMMA)
              unless _tmp
                self.pos = _save5
              end
              break
            end # end sequence

            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_json_attr)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_CLOSE)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save6 = self.pos
      while true # sequence
        _tmp = apply(:_LBRACK)
        unless _tmp
          self.pos = _save6
          break
        end
        _save7 = self.pos

        _save8 = self.pos
        while true # sequence
          while true

            _save10 = self.pos
            while true # sequence
              _tmp = apply(:_json_part)
              unless _tmp
                self.pos = _save10
                break
              end
              _tmp = apply(:_COMMA)
              unless _tmp
                self.pos = _save10
              end
              break
            end # end sequence

            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save8
            break
          end
          _tmp = apply(:_json_part)
          unless _tmp
            self.pos = _save8
          end
          break
        end # end sequence

        unless _tmp
          _tmp = true
          self.pos = _save7
        end
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = apply(:_RBRACK)
        unless _tmp
          self.pos = _save6
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_STRING)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_json_part unless _tmp
    return _tmp
  end

  # json_attr = STRING COLON json_part
  def _json_attr

    _save = self.pos
    while true # sequence
      _tmp = apply(:_STRING)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_COLON)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_json_part)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_json_attr unless _tmp
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

  # junk = (SEPARATOR | COMMA | JUNK_EXPR)
  def _junk

    _save = self.pos
    while true # choice
      _tmp = apply(:_SEPARATOR)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_COMMA)
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

  # JUNK_EXPR = < /[^;,{}]+/ > { nil }
  def _JUNK_EXPR

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[^;,{}]+)/)
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

  # OPEN = < /\s*\{\s*/ > { text }
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
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_OPEN unless _tmp
    return _tmp
  end

  # CLOSE = < /\s*\}\s*/ > { text }
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
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_CLOSE unless _tmp
    return _tmp
  end

  # LPAREN = < /\s*\(\s*/ > { text }
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
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_LPAREN unless _tmp
    return _tmp
  end

  # RPAREN = < /\s*\)\s*/ > { text }
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
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_RPAREN unless _tmp
    return _tmp
  end

  # COMMA = < /\s*\,\s*/ > { text }
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
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_COMMA unless _tmp
    return _tmp
  end

  # COLON = < /\s*\:\s*/ > { nil }
  def _COLON

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\:\s*)/)
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

    set_failed_rule :_COLON unless _tmp
    return _tmp
  end

  # ASSIGN = < /\s*\=\s*/ > { text }
  def _ASSIGN

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\=\s*)/)
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

    set_failed_rule :_ASSIGN unless _tmp
    return _tmp
  end

  # LBRACK = < /\s*\[\s*/ > { text }
  def _LBRACK

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\[\s*)/)
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

    set_failed_rule :_LBRACK unless _tmp
    return _tmp
  end

  # RBRACK = < /\s*\]\s*/ > { text }
  def _RBRACK

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\s*\]\s*)/)
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

    set_failed_rule :_RBRACK unless _tmp
    return _tmp
  end

  # STRING = < /\'([^'\\]|\\.)*\'|\"([^"\\]|\\.)*\"/ > {make_string(text)}
  def _STRING

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:\'([^'\\]|\\.)*\'|\"([^"\\]|\\.)*\")/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; make_string(text); end
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
  Rules[:_lines] = rule_info("lines", "line(prefix)*:lines {output(lines)}")
  Rules[:_line] = rule_info("line", "(relevant(prefix) | block(prefix) | < junk > { text })")
  Rules[:_relevant] = rule_info("relevant", "(prefix_override | data_definition(prefix) | attribute(prefix) | single_call(prefix) | chained_call(prefix) | chained_with_assignment(prefix) | ads_call(prefix) | scope(prefix))")
  Rules[:_block] = rule_info("block", "OPEN:op lines(prefix):li CLOSE:cl { [op, li, cl] }")
  Rules[:_scope] = rule_info("scope", "< EXT DOT meth_of_type(\"scope\"):ident LPAREN STRING:param COMMA > {join_keys(prefix, param)}:new_prefix block(new_prefix):lines_src RPAREN:right_src { [text, lines_src, right_src] }")
  Rules[:_single_call] = rule_info("single_call", "< THIS DOT meth_of_type(\"setter\"):ident LPAREN > STRING:value RPAREN:right_src {translate_setter_to_key(ident)}:key {translate(prefix, key, value)}:translated_value { [text, translated_value, right_src] }")
  Rules[:_chained_call] = rule_info("chained_call", "< THIS DOT meth_of_type(\"finder\"):ident LPAREN STRING:key RPAREN:right_src DOT meth_of_type(\"any\") LPAREN > STRING:value RPAREN:right_src {translate(prefix, key, value)}:translated_value { [text, translated_value, right_src] }")
  Rules[:_chained_with_assignment] = rule_info("chained_with_assignment", "< THIS DOT meth_of_type(\"finder\"):ident LPAREN STRING:key RPAREN:right_src DOT meth_of_type(\"any\") ASSIGN > STRING:value {translate(prefix, key, value)}:translated_value { [text, translated_value] }")
  Rules[:_ads_call] = rule_info("ads_call", "< \"ads\" DOT \"app\" DOT meth_of_type(\"any\") LPAREN STRING:key1 RPAREN DOT meth_of_type(\"any\"):key2 ASSIGN > STRING:value {join_keys(key1, key2)}:key {translate(prefix, key, value)}:translated_value { [text, translated_value] }")
  Rules[:_attribute] = rule_info("attribute", "< meth_of_type(\"attribute\"):key COLON > STRING:value COMMA:right_src {translate(prefix, key, value)}:translated_value { [text, translated_value, right_src] }")
  Rules[:_data_definition] = rule_info("data_definition", "< meth_of_type(\"data\"):data COLON > json(prefix):json { [text, json] }")
  Rules[:_prefix_override] = rule_info("prefix_override", "< \"override\" COLON STRING:new_prefix > lines(new_prefix):li { [text, li] }")
  Rules[:_json] = rule_info("json", "< json_part > {translate_json(prefix, text)}:translated_json { translated_json }")
  Rules[:_json_part] = rule_info("json_part", "(OPEN ((json_attr COMMA)* json_attr)? CLOSE | LBRACK ((json_part COMMA)* json_part)? RBRACK | STRING)")
  Rules[:_json_attr] = rule_info("json_attr", "STRING COLON json_part")
  Rules[:_meth_of_type] = rule_info("meth_of_type", "IDENTIFIER:i &{ matches_type? i, type } { i }")
  Rules[:_junk] = rule_info("junk", "(SEPARATOR | COMMA | JUNK_EXPR)")
  Rules[:_JUNK_EXPR] = rule_info("JUNK_EXPR", "< /[^;,{}]+/ > { nil }")
  Rules[:_SEPARATOR] = rule_info("SEPARATOR", "< /\\s*\\;\\s*/ > { nil }")
  Rules[:_OPEN] = rule_info("OPEN", "< /\\s*\\{\\s*/ > { text }")
  Rules[:_CLOSE] = rule_info("CLOSE", "< /\\s*\\}\\s*/ > { text }")
  Rules[:_LPAREN] = rule_info("LPAREN", "< /\\s*\\(\\s*/ > { text }")
  Rules[:_RPAREN] = rule_info("RPAREN", "< /\\s*\\)\\s*/ > { text }")
  Rules[:_COMMA] = rule_info("COMMA", "< /\\s*\\,\\s*/ > { text }")
  Rules[:_COLON] = rule_info("COLON", "< /\\s*\\:\\s*/ > { nil }")
  Rules[:_ASSIGN] = rule_info("ASSIGN", "< /\\s*\\=\\s*/ > { text }")
  Rules[:_LBRACK] = rule_info("LBRACK", "< /\\s*\\[\\s*/ > { text }")
  Rules[:_RBRACK] = rule_info("RBRACK", "< /\\s*\\]\\s*/ > { text }")
  Rules[:_STRING] = rule_info("STRING", "< /\\'([^'\\\\]|\\\\.)*\\'|\\\"([^\"\\\\]|\\\\.)*\\\"/ > {make_string(text)}")
  Rules[:_DOT] = rule_info("DOT", "\".\"")
  Rules[:_EXT] = rule_info("EXT", "\"Ext\"")
  Rules[:_THIS] = rule_info("THIS", "\"this\"")
  Rules[:_IDENTIFIER] = rule_info("IDENTIFIER", "< /\\w+/ > { text }")
  # :startdoc:
end
