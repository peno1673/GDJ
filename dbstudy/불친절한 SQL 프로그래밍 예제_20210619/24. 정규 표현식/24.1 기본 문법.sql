--
SELECT REGEXP_SUBSTR ('aab', 'a.b') AS c1
     , REGEXP_SUBSTR ('abb', 'a.b') AS c2
     , REGEXP_SUBSTR ('acb', 'a.b') AS c3
     , REGEXP_SUBSTR ('adc', 'a.b') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('a' , 'a|b'  ) AS c1 -- a 또는 b
     , REGEXP_SUBSTR ('b' , 'a|b'  ) AS c2
     , REGEXP_SUBSTR ('c' , 'a|b'  ) AS c3
     , REGEXP_SUBSTR ('ab', 'ab|cd') AS c4 -- ab 또는 cd
     , REGEXP_SUBSTR ('cd', 'ab|cd') AS c5
     , REGEXP_SUBSTR ('bc', 'ab|cd') AS c6
     , REGEXP_SUBSTR ('aa', 'a|aa' ) AS c7 -- a 또는 aa
     , REGEXP_SUBSTR ('aa', 'aa|a' ) AS c8
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('a|b', 'a|b' ) AS c1
     , REGEXP_SUBSTR ('a|b', 'a\|b') AS c2
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '^.', 1, 1     ) AS c1
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '^.', 1, 2     ) AS c2
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '^.', 1, 1, 'm') AS c3
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '^.', 1, 2, 'm') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '.$', 1, 1     ) AS c1
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '.$', 1, 2     ) AS c2
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '.$', 1, 1, 'm') AS c3
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '.$', 1, 2, 'm') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ac'  , 'ab?c') AS c1 -- ac, abc
     , REGEXP_SUBSTR ('abc' , 'ab?c') AS c2
     , REGEXP_SUBSTR ('abbc', 'ab?c') AS c3
     , REGEXP_SUBSTR ('ac'  , 'ab*c') AS c4 -- ac, abc, abbc, abbbc, …
     , REGEXP_SUBSTR ('abc' , 'ab*c') AS c5
     , REGEXP_SUBSTR ('abbc', 'ab*c') AS c6
     , REGEXP_SUBSTR ('ac'  , 'ab+c') AS c7 -- abc, abbc, abbbc, abbbbc, …
     , REGEXP_SUBSTR ('abc' , 'ab+c') AS c8
     , REGEXP_SUBSTR ('abbc', 'ab+c') AS c9
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ab'   , 'a{2}'  ) AS c1 -- aa
     , REGEXP_SUBSTR ('aab'  , 'a{2}'  ) AS c2
     , REGEXP_SUBSTR ('aab'  , 'a{3,}' ) AS c3 -- aaa, aaaa, …
     , REGEXP_SUBSTR ('aaab' , 'a{3,}' ) AS c4
     , REGEXP_SUBSTR ('aaab' , 'a{4,5}') AS c5 -- aaaa, aaaaa
     , REGEXP_SUBSTR ('aaaab', 'a{4,5}') AS c6
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ababc', '(ab)+c' ) AS c1 -- abc, ababc, …
     , REGEXP_SUBSTR ('ababc', 'ab+c'   ) AS c2 -- abc, abbc, …
     , REGEXP_SUBSTR ('abd'  , 'a(b|c)d') AS c3 -- abd, acd
     , REGEXP_SUBSTR ('abd'  , 'ab|cd'  ) AS c4 -- ab, cd
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('abxab' , '(ab|cd)x\1') AS c1 -- abxab, cdxcd
     , REGEXP_SUBSTR ('cdxcd' , '(ab|cd)x\1') AS c2
     , REGEXP_SUBSTR ('abxef' , '(ab|cd)x\1') AS c3
     , REGEXP_SUBSTR ('ababab', '(.*)\1+'   ) AS c4
     , REGEXP_SUBSTR ('abcabc', '(.*)\1+'   ) AS c5
     , REGEXP_SUBSTR ('abcabd', '(.*)\1+'   ) AS c6
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ac', '[ab]c' ) AS c1 -- ac, bc
     , REGEXP_SUBSTR ('bc', '[ab]c' ) AS c2
     , REGEXP_SUBSTR ('cc', '[ab]c' ) AS c3
     , REGEXP_SUBSTR ('ac', '[^ab]c') AS c4 -- ac, bc가 아닌 문자열
     , REGEXP_SUBSTR ('bc', '[^ab]c') AS c5
     , REGEXP_SUBSTR ('cc', '[^ab]c') AS c6
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('1a', '[0-9][a-z]'  ) AS c1
     , REGEXP_SUBSTR ('9z', '[0-9][a-z]'  ) AS c2
     , REGEXP_SUBSTR ('aA', '[^0-9][^a-z]') AS c3
     , REGEXP_SUBSTR ('Aa', '[^0-9][^a-z]') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('gF1,', '[[:digit:]]' ) AS c1
     , REGEXP_SUBSTR ('gF1,', '[[:alpha:]]' ) AS c2
     , REGEXP_SUBSTR ('gF1,', '[[:lower:]]' ) AS c3
     , REGEXP_SUBSTR ('gF1,', '[[:upper:]]' ) AS c4
     , REGEXP_SUBSTR ('gF1,', '[[:alnum:]]' ) AS c5
     , REGEXP_SUBSTR ('gF1,', '[[:xdigit:]]') AS c6
     , REGEXP_SUBSTR ('gF1,', '[[:punct:]]' ) AS c7
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('a b'                , 'a[[:blank:]]b') AS c1
     , REGEXP_SUBSTR ('a' || CHR (9) || 'b', 'a[[:blank:]]b') AS c2
     , REGEXP_SUBSTR ('a b'                , 'a[[:space:]]b') AS c3
     , REGEXP_SUBSTR ('a' || CHR (9) || 'b', 'a[[:space:]]b') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('a b', 'a[[:cntrl:]]b') AS c1
     , REGEXP_SUBSTR ('a b', 'a[[:print:]]b') AS c2
     , REGEXP_SUBSTR ('a b', 'a[[:graph:]]b') AS c3
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('(650) 555-0100', '^\(\d{3}\) \d{3}-\d{4}$') AS c1
     , REGEXP_SUBSTR ('650-555-0100'  , '^\(\d{3}\) \d{3}-\d{4}$') AS c2
     , REGEXP_SUBSTR ('b2b', '\w\d\D') AS c3
     , REGEXP_SUBSTR ('b2_', '\w\d\D') AS c4
     , REGEXP_SUBSTR ('b22', '\w\d\D') AS c5
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('jdoe@company.co.uk', '\w+@\w+(\.\w+)+') AS c1
     , REGEXP_SUBSTR ('jdoe@company'      , '\w+@\w+(\.\w+)+') AS c2
     , REGEXP_SUBSTR ('to: bill', '\w+\W\s\w+') AS c3
     , REGEXP_SUBSTR ('to bill' , '\w+\W\s\w+') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('(a b )', '\(\w\s\w\s\)') AS c1
     , REGEXP_SUBSTR ('(a b )', '\(\w\S\w\S\)') AS c2
     , REGEXP_SUBSTR ('(a,b.)', '\(\w\s\w\s\)') AS c3
     , REGEXP_SUBSTR ('(a,b.)', '\(\w\S\w\S\)') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '\A\w', 1, 1, 'm') AS c1
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '^\w' , 1, 1, 'm') AS c2
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '\A\w', 1, 2, 'm') AS c3
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'cd', '^\w' , 1, 2, 'm') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('ab'||CHR (10)||'cd'||CHR (10), '\w\Z', 1, 1, 'm') AS c1
     , REGEXP_SUBSTR ('ab'||CHR (10)||'cd'||CHR (10), '\w\z', 1, 1, 'm') AS c2
     , REGEXP_SUBSTR ('ab'||CHR (10)||'cd'||CHR (10), '\w$' , 1, 1, 'm') AS c3
     , REGEXP_SUBSTR ('ab'||CHR (10)||'cd'||CHR (10), '\w$' , 1, 2, 'm') AS c4
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('aaaa'  , 'a??aa'  ) AS c1 -- nongreedy 방식
     , REGEXP_SUBSTR ('aaaa'  , 'a?aa'   ) AS c2 -- greedy 방식
     , REGEXP_SUBSTR ('xaxbxc', '\w*?x\w') AS c3
     , REGEXP_SUBSTR ('xaxbxc', '\w*x\w' ) AS c4
     , REGEXP_SUBSTR ('abxcxd', '\w+?x\w') AS c5
     , REGEXP_SUBSTR ('abxcxd', '\w+x\w' ) AS c6
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('aaaa'  , 'a{2}?'  ) AS c1 -- nongreedy 방식
     , REGEXP_SUBSTR ('aaaa'  , 'a{2}'   ) AS c2 -- greedy 방식
     , REGEXP_SUBSTR ('aaaaa ', 'a{2,}?' ) AS c3
     , REGEXP_SUBSTR ('aaaaa ', 'a{2,}'  ) AS c4
     , REGEXP_SUBSTR ('aaaaa ', 'a{2,4}?') AS c5
     , REGEXP_SUBSTR ('aaaaa ', 'a{2,4}' ) AS c6
  FROM DUAL;
