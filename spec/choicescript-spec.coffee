describe "ChoiceScript grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-choicescript")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.choicescript")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.choicescript"

  it "tokenizes the general keywords", ->
    assertGeneralKeyword('*scene_list')
    assertGeneralKeyword('*page_break')
    assertGeneralKeyword('*line_break')
    assertGeneralKeyword('*choice')
    assertGeneralKeyword('*finish')
    assertGeneralKeyword('*label')
    assertGeneralKeyword('*goto')
    assertGeneralKeyword('*goto_scene')
    assertGeneralKeyword('*gosub')
    assertGeneralKeyword('*gosub_scene')
    assertGeneralKeyword('*return')
    assertGeneralKeyword('*ending')
    assertGeneralKeyword('*image')
    assertGeneralKeyword('*if')
    assertGeneralKeyword('*else')
    assertGeneralKeyword('*elseif')
    assertGeneralKeyword('*temp')
    assertGeneralKeyword('*stat_chart')
    assertGeneralKeyword('*rand')
    assertGeneralKeyword('*input_number')

  it "tokenizes title", -> assertPair('*title A cool title', ['*title', 'A cool title'], 'title')

  it "tokenizes author", -> assertPair('*author Kingsley Hendrickse', ['*author', 'Kingsley Hendrickse'], 'author')

  it "tokenizes link", -> assertPair('*link http://www.someplace.com', ['*link', 'http://www.someplace.com'], 'link')

  it "tokenizes option", -> assertPair('#The first option', ['#', 'The first option'], 'option', false)

  it "tokenizes comments", ->
    {tokens} = grammar.tokenizeLine('*comment some comment')
    expect(tokens[0]).toEqual value: '*comment some comment', scopes: ['source.choicescript', 'comment.line.choicescript']

    {tokens} = grammar.tokenizeLine('*comment')
    expect(tokens[0]).toEqual value: '*comment', scopes: ['source.choicescript', 'comment.line.choicescript']

  it "tokenizes create", -> assertTriple('*create leadership 10', ['*create', 'leadership', '10'], 'create')

  it "tokenizes set", -> assertTriple('*set leadership +10', ['*set', 'leadership', '+10'], 'set')

  it "tokenizes operators", ->
    assertOperator('(')
    assertOperator(')')
    assertOperator('[')
    assertOperator(']')
    assertOperator('{')
    assertOperator('}')
    assertOperator('$')
    assertOperator('/')
    assertOperator('=')
    assertOperator('!')
    assertOperator('>')
    assertOperator('<')
    assertOperator(':')

  assertOperator = (operator) ->
    {tokens} = grammar.tokenizeLine(operator)
    expect(tokens[0]).toEqual value: operator, scopes: ['source.choicescript', 'constant.numeric.choicescript']

  assertTriple = (phrase, expected_tokens_list, item) ->
    {tokens} = grammar.tokenizeLine(phrase)
    expect(tokens[0]).toEqual value: expected_tokens_list[0], scopes: ['source.choicescript', 'meta.' + item + '.choicescript', 'entity.name.function.choicescript']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.choicescript', 'meta.' + item + '.choicescript']
    expect(tokens[2]).toEqual value: expected_tokens_list[1], scopes: ['source.choicescript', 'meta.' + item + '.choicescript', 'keyword.control.choicescript']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.choicescript', 'meta.' + item + '.choicescript']
    expect(tokens[4]).toEqual value: expected_tokens_list[2], scopes: ['source.choicescript', 'meta.' + item + '.choicescript', 'constant.numeric.choicescript']

  assertPair = (phrase, expected_tokens_list, item, has_space = true) ->
    {tokens} = grammar.tokenizeLine(phrase)
    expect(tokens[0]).toEqual value: expected_tokens_list[0], scopes: ['source.choicescript', 'meta.' + item + '.choicescript', 'entity.name.function.choicescript']
    if(has_space)
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.choicescript', 'meta.' + item + '.choicescript']
      expect(tokens[2]).toEqual value: expected_tokens_list[1], scopes: ['source.choicescript', 'meta.' + item + '.choicescript', 'string.unquoted']
    else
     expect(tokens[1]).toEqual value: expected_tokens_list[1], scopes: ['source.choicescript', 'meta.' + item + '.choicescript', 'string.unquoted']

  assertGeneralKeyword = (keyword) ->
    {tokens} = grammar.tokenizeLine(keyword)
    expect(tokens[0]).toEqual value: keyword, scopes: ['source.choicescript', 'entity.name.function.choicescript']
