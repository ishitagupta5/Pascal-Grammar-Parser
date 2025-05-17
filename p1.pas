(*
  p1.pas

  CS 3304 Project #1
  Ishita Gupta
  Date: 2/24/2025

  Honor Code:
  I have neither given nor received unauthorized aid in completing this work,
  nor have I presented someone else’s work as my own.

  Grammar:
    <sentence>    -->  <subject> <verb_phrase> <object>
    <subject>     -->  <noun_phrase>
    <verb_phrase> -->  <verb> | <verb> <adv>
    <object>      -->  <noun_phrase>
    <verb>        -->  lifted | saw | found
    <adv>         -->  quickly | carefully | brilliantly
    <noun_phrase> -->  [<adj_phrase>] <noun> [<prep_phrase>]
    <noun>        -->  cow | alice | book
    <adj_phrase>  -->  <adj> | <adj> <adj_phrase>
    <adj>         -->  green | lean | mean
    <prep_phrase> -->  <prep> <noun_phrase>
    <prep>        -->  of | at | with

*)

program p1(input, output);

{ Maximum number of tokens allowed per input line }
const
  MAX_TOKENS = 200;

{ Type definition for an array of tokens }
type
  TStringArray = array[1..MAX_TOKENS] of string;

{ Global variables }
var
  inFile, outFile: Text;       
  line:      string;          
  tokens:    TStringArray;     
  numTokens: integer;          
  idx:       integer;          

  errorFlag:    boolean;       
  errorMessage: string;        
  parseOutput:  string;        

{ 
  toLower: Converts a given string to lowercase.
  Parameters: 
    - s: The input string.
  Returns:
    - The lower-case version of the input string.
}
function toLower(const s: string): string;
var
  i: integer;
  temp: string;
begin
  temp := s;
  for i := 1 to length(temp) do
    if (temp[i] >= 'A') and (temp[i] <= 'Z') then
      temp[i] := chr(ord(temp[i]) + 32);
  toLower := temp;
end;

{ 
  setError: Sets the error flag and error message.
  Parameters:
    - msg: The error message to be set.
}
procedure setError(msg: string);
begin
  errorFlag := true;
  errorMessage := msg;
end;

{ 
  advanceToken: Increments the global token index to move to the next token.
}
procedure advanceToken;
begin
  Inc(idx);
end;

{ 
  currentToken: Returns the current token from the tokens array.
  Returns:
    - The token at the current index, or an empty string if out of bounds.
}
function currentToken: string;
begin
  if (idx >= 1) and (idx <= numTokens) then
    currentToken := tokens[idx]
  else
    currentToken := '';
end;

{ 
  atEnd: Checks if we have processed all tokens.
  Returns:
    - True if the current index is beyond the last token; otherwise, false.
}
function atEnd: boolean;
begin
  atEnd := (idx > numTokens);
end;

{ 
  isValidToken: Checks if a token is one of the valid tokens in the grammar.
  Parameters:
    - t: The token to check.
  Returns:
    - True if the token is valid, false otherwise.
}
function isValidToken(const t: string): boolean;
begin
  if ((t = 'lifted') or (t = 'saw') or (t = 'found') or
      (t = 'quickly') or (t = 'carefully') or (t = 'brilliantly') or
      (t = 'cow') or (t = 'alice') or (t = 'book') or
      (t = 'green') or (t = 'lean') or (t = 'mean') or
      (t = 'of') or (t = 'at') or (t = 'with')) then
    isValidToken := true
  else
    isValidToken := false;
end;

{ 
  tokenizeLine: Splits an input line into tokens.
  Parameters:
    - line: The input line.
    - arr: The array where tokens will be stored.
    - count: Returns the number of tokens found.
  Description:
    Skips whitespace and extracts each token, converting it to lower-case.
}
procedure tokenizeLine(const line: string; var arr: TStringArray; var count: integer);
var
  i, startPos, L: integer;
begin
  count := 0;
  L := length(line);
  i := 1;

  while i <= L do
  begin
    { Skip whitespace (space and tab) }
    while (i <= L) and (line[i] in [' ', #9]) do
      inc(i);

    if i > L then
      break;

    startPos := i;
    { Read until next whitespace }
    while (i <= L) and not (line[i] in [' ', #9]) do
      inc(i);

    inc(count);
    if (count <= MAX_TOKENS) then
      arr[count] := toLower(copy(line, startPos, i - startPos));
  end;
end;

procedure parseSentence; forward;
procedure parseNounPhrase; forward;
procedure parseVerbPhrase; forward;
procedure parsePrepPhrase; forward;
procedure parseAdjPhrase; forward;
procedure parseNoun; forward;
procedure parseVerb; forward;
procedure parseAdverb; forward;

{ 
  parseSentence: Parses a <sentence> according to:
    <sentence> --> <subject> <verb_phrase> <object>
  Description:
    Wraps the entire sentence in outer parentheses.
    Checks for extra tokens after the expected sentence.
}
procedure parseSentence;
begin
  { Start outer parentheses for the sentence }
  parseOutput := '(';   

  { Parse the subject (a noun phrase) and wrap it }
  parseOutput := parseOutput + '(';
  parseNounPhrase;
  parseOutput := parseOutput + ')';

  if errorFlag then Exit;

  parseOutput := parseOutput + ' ';

  { Parse the verb phrase and wrap it }
  parseOutput := parseOutput + '(';
  parseVerbPhrase;
  parseOutput := parseOutput + ')';

  if errorFlag then Exit;

  parseOutput := parseOutput + ' ';

  { Parse the object (a noun phrase) and wrap it }
  parseOutput := parseOutput + '(';
  parseNounPhrase;
  parseOutput := parseOutput + ')';

  { Check for leftover tokens: if tokens remain, it's an error }
  if (not errorFlag) and (not atEnd) then
    setError('Input is not a sentence.');
  
  { Close outer sentence parentheses }
  parseOutput := parseOutput + ')';
end;

{ 
  parseNounPhrase: Parses a <noun_phrase> according to:
    <noun_phrase> --> [<adj_phrase>] <noun> [<prep_phrase>]
  Description:
    Always outputs an outer pair of parentheses around the noun phrase.
    Optionally includes an adjective phrase and a prepositional phrase.
}
procedure parseNounPhrase;
begin
  { Open noun phrase parentheses }
  parseOutput := parseOutput + '(';

  { Optional adjective phrase }
  if (currentToken = 'green') or
     (currentToken = 'lean')  or
     (currentToken = 'mean') then
  begin
    parseAdjPhrase;
    if errorFlag then
    begin
      parseOutput := parseOutput + ')';
      Exit;
    end;
  end;

  { Parse the noun }
  parseNoun;
  if errorFlag then
  begin
    parseOutput := parseOutput + ')';
    Exit;
  end;

  { Optional prepositional phrase }
  if (currentToken = 'of') or
     (currentToken = 'at') or
     (currentToken = 'with') then
  begin
    { Wrap the prep phrase in an extra set of parentheses }
    parseOutput := parseOutput + '(';
    parsePrepPhrase;
    parseOutput := parseOutput + ')';
    if errorFlag then
    begin
      parseOutput := parseOutput + ')';
      Exit;
    end;
  end;

  { Close noun phrase parentheses }
  parseOutput := parseOutput + ')';
end;

{ 
  parseAdjPhrase: Parses an <adj_phrase> according to:
    <adj_phrase> --> <adj> | <adj> <adj_phrase>
  Description:
    For a single adjective, outputs (adj). For multiple adjectives, groups them.
}
procedure parseAdjPhrase;
var
  firstAdj: string;
  temp: string;
begin
  { Ensure the current token is a valid adjective }
  if (currentToken <> 'green') and
     (currentToken <> 'lean')  and
     (currentToken <> 'mean') then
  begin
    setError('Input is not a sentence.');
    Exit;
  end;

  firstAdj := currentToken;
  advanceToken;

  { If there is another adjective, group them together }
  if (currentToken = 'green') or
     (currentToken = 'lean') or
     (currentToken = 'mean') then
  begin
    temp := '(' + firstAdj;
    while (currentToken = 'green') or
          (currentToken = 'lean') or
          (currentToken = 'mean') do
    begin
      temp := temp + '(' + currentToken + ')';
      advanceToken;
    end;
    temp := temp + ')';
    { Output grouped adjectives, e.g., (mean(green)) }
    parseOutput := parseOutput + temp;
  end
  else
  begin
    { Only one adjective }
    parseOutput := parseOutput + '(' + firstAdj + ')';
  end;
end;

{ 
  parseNoun: Parses a <noun> according to:
    <noun> --> cow | alice | book
  Description:
    Outputs the noun and advances to the next token.
}
procedure parseNoun;
begin
  if (currentToken = 'cow') or
     (currentToken = 'alice') or
     (currentToken = 'book') then
  begin
    parseOutput := parseOutput + currentToken;
    advanceToken;
  end
  else
    setError('Input is not a sentence.');
end;

{ 
  parseVerbPhrase: Parses a <verb_phrase> according to:
    <verb_phrase> --> <verb> | <verb> <adv>
  Description:
    First parses the verb, then optionally an adverb if present.
}
procedure parseVerbPhrase;
begin
  parseVerb;
  if errorFlag then Exit;

  { Check for an optional adverb }
  if (currentToken = 'quickly') or
     (currentToken = 'carefully') or
     (currentToken = 'brilliantly') then
  begin
    parseAdverb;
  end;
end;

{ 
  parseVerb: Parses a <verb> according to:
    <verb> --> lifted | saw | found
  Description:
    Outputs the verb and advances to the next token.
}
procedure parseVerb;
begin
  if (currentToken = 'lifted') or
     (currentToken = 'saw') or
     (currentToken = 'found') then
  begin
    parseOutput := parseOutput + currentToken;
    advanceToken;
  end
  else
    setError('Input is not a sentence.');
end;

{ 
  parseAdverb: Parses an <adverb> according to:
    <adverb> --> quickly | carefully | brilliantly
  Description:
    Outputs the adverb (preceded by a space) and advances to the next token.
}
procedure parseAdverb;
begin
  if (currentToken = 'quickly') or
     (currentToken = 'carefully') or
     (currentToken = 'brilliantly') then
  begin
    parseOutput := parseOutput + ' ' + currentToken;
    advanceToken;
  end
  else
    setError('Input is not a sentence.');
end;

{ 
  parsePrepPhrase: Parses a <prep_phrase> according to:
    <prep_phrase> --> <prep> <noun_phrase>
  Description:
    Outputs the preposition and then calls parseNounPhrase to output the argument.
    No extra parentheses are added here since parseNounPhrase handles its own grouping.
}
procedure parsePrepPhrase;
var
  p: string;
begin
  if (currentToken = 'of') or
     (currentToken = 'at') or
     (currentToken = 'with') then
  begin
    p := currentToken;
    advanceToken;
    parseOutput := parseOutput + p;
    parseNounPhrase;
  end
  else
    setError('Input is not a sentence.');
end;

var
  inputFileName, outputFileName: string;

begin
  { Check that both input and output file names are provided }
  if ParamCount < 2 then
  begin
    writeln('Usage: ', ParamStr(0), ' <inputfile> <outputfile>');
    halt(1);
  end;

  { Open the input and output files }
  inputFileName  := ParamStr(1);
  outputFileName := ParamStr(2);

  Assign(inFile, inputFileName);
  Reset(inFile);

  Assign(outFile, outputFileName);
  Rewrite(outFile);

  { Process each line from the input file }
  while not EOF(inFile) do
  begin
    readln(inFile, line);

    { Skip empty or whitespace-only lines }
    if (line = '') then
      continue;

    { Tokenize the current line }
    tokenizeLine(line, tokens, numTokens);
    if (numTokens = 0) then
      continue;

    { Output the input line }
    writeln(outFile, 'input-line => ', line);

    { Check each token for validity }
    errorFlag := false;
    errorMessage := '';
    for idx := 1 to numTokens do
      if not isValidToken(tokens[idx]) then
      begin
        errorFlag := true;
        errorMessage := 'Input has invalid tokens.';
        break;
      end;

    { If invalid tokens are found, output error and move to next line }
    if errorFlag then
    begin
      writeln(outFile, #9, errorMessage);
      continue;
    end;

    { Initialize the token index and output string, then parse the sentence }
    idx := 1;
    parseOutput := '';
    parseSentence;

    { Output the result: either the parsed diagram or an error message }
    if errorFlag then
      writeln(outFile, #9, errorMessage)
    else
      writeln(outFile, #9, parseOutput);
  end;

  { Close the input and output files }
  Close(inFile);
  Close(outFile);
end.
