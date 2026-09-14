; inherits: html

; Upstream marks these @tag, which renders them exactly like the surrounding
; HTML elements. @keyword sets Blade's own control flow apart from the markup.
[
  (directive)
  (directive_start)
  (directive_end)
] @keyword

[
  (php_tag)
  (php_end_tag)
  "{{"
  "}}"
  "{!!"
  "!!}"
  "("
  ")"
] @punctuation.bracket
