(use-package cheatsheet
  :ensure t
  :config
  (cheatsheet-add :group 'Test
                  :key "C-x C-c"
                  :description "Leave Emacs :'(")

  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ef"
                  :description "extract-function: Extracts the marked expressions out into a new named function.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m em"
                  :description "extract-method: Extracts the marked expressions out into a new named method in an object literal.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ip"
                  :description "introduce-parameter: Changes the marked expression to a parameter in a local function.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m lp"
                  :description "localize-parameter: Changes a parameter to a local var in a local function.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m eo"
                  :description "expand-object: Converts a one line object literal to multiline.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m co"
                  :description "contract-object: Converts a multiline object literal to one line.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m eu"
                  :description "expand-function: Converts a one line function to multiline (expecting semicolons as statement delimiters).")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m cu"
                  :description "contract-function: Converts a multiline function to one line (expecting semicolons as statement delimiters).")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ea"
                  :description "expand-array: Converts a one line array to multiline.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ca"
                  :description "contract-array: Converts a multiline array to one line.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m wi"
                  :description "wrap-buffer-in-iife: Wraps the entire buffer in an immediately invoked function expression")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ig"
                  :description "inject-global-in-iife: Creates a shortcut for a marked global by injecting it in the wrapping immediately invoked function expression")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ag"
                  :description "add-to-globals-annotation: Creates a /*global */ annotation if it is missing, and adds the var at point to it.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ev"
                  :description "extract-var: Takes a marked expression and replaces it with a var.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m iv"
                  :description "inline-var: Replaces all instances of a variable with its initial value.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m rv"
                  :description "rename-var: Renames the variable on point and all occurrences in its lexical scope.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m vt"
                  :description "var-to-this: Changes local var a to be this.a instead.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ao"
                  :description "arguments-to-object: Replaces arguments to a function call with an object literal of named arguments.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m 3i"
                  :description "ternary-to-if: Converts ternary operator to if-statement.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m sv"
                  :description "split-var-declaration: Splits a var with multiple vars declared, into several var statements.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ss"
                  :description "split-string: Splits a string.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m uw"
                  :description "unwrap: Replaces the parent statement with the selected region.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m lt"
                  :description "log-this: Adds a console.log() statement for what is at point (or region).")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m dt"
                  :description "debug-this: Adds a debug() statement for what is at point (or region).")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m sl"
                  :description "forward-slurp: Moves the next statement into current function, if-statement, for-loop or while-loop.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m ba"
                  :description "forward-barf: Moves the last child out of current function, if-statement, for-loop or while-loop.")
  (cheatsheet-add :group 'js2Refactor
                  :key "C-c C-m k"
                  :description "kill: Kills to the end of the line, but does not cross semantic boundaries.")
  :bind ("C-c C-s" . cheatsheet-show))


;; (package-require 'cheatsheet)





;; (global-set-key (kbd "C-c C-s") 'cheatsheet-show)
(provide 'cheatsheet-settings)
