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


    (cheatsheet-add :group 'PageMovement :key "C-v" :description "Siguiente")
    (cheatsheet-add :group 'PageMovement :key "M-v" :description "Anterior")

    (cheatsheet-add :group 'TextMovement :key "C-f" :description "Moverse un caracter hacia adelante")
    (cheatsheet-add :group 'TextMovement :key "C-b" :description "Moverse un caracter hacia atrás")
    (cheatsheet-add :group 'TextMovement :key "M-f" :description "Moverse una palabra hacia adelante")
    (cheatsheet-add :group 'TextMovement :key "M-b" :description "Moverse una palabra hacia atrás")
    (cheatsheet-add :group 'TextMovement :key "C-n" :description "Moverse a la siguiente línea")
    (cheatsheet-add :group 'TextMovement :key "C-p" :description "Moverse a la línea anterior")
    (cheatsheet-add :group 'TextMovement :key "C-a" :description "Moverse al comienzo de una líneas")
    (cheatsheet-add :group 'TextMovement :key "C-e" :description "Moverse al final de una línea")
    (cheatsheet-add :group 'TextMovement :key "M-a" :description "Moverse al inicio de una oracion")
    (cheatsheet-add :group 'TextMovement :key "M-e" :description "Moverse al final de una oracion")

    (cheatsheet-add :group 'ModifyText :key "C-k" :description "mata el texto, pero puede ser recuperado con C-y")
    (cheatsheet-add :group 'ModifyText :key "C-d" :description "Borra un caracter (no puede ser recuperado)")
    (cheatsheet-add :group 'ModifyText :key "M-d" :description "Borra una plabra")
    (cheatsheet-add :group 'ModifyText :key "C-Spa" :description "Marca el texto")
    (cheatsheet-add :group 'ModifyText :key "C-w" :description "Corta el texto seleccionado")
    (cheatsheet-add :group 'ModifyText :key "M-w" :description "Copia el texto seleccionado")
    (cheatsheet-add :group 'ModifyText :key "C-h" :description "Marca todo el buffer")
    (cheatsheet-add :group 'ModifyText :key "C-y" :description "Pega el texto copiado")
    (cheatsheet-add :group 'ModifyText :key "M-y" :description "Recorre los textos copiados/pegados")
    (cheatsheet-add :group 'ModifyText :key "C-g" :description "Cancelar comando")
    (cheatsheet-add :group 'ModifyText :key "C-x-u" :description "Deshacer")
    (cheatsheet-add :group 'ModifyText :key "C-/" :description "Deshacer ")


    (cheatsheet-add :group 'ControlXs :key "C-x C-f" :description "Abrir/crear un archivo")
    (cheatsheet-add :group 'ControlXs :key "C-x C-x" :description "Listar Buffers")
    (cheatsheet-add :group 'ControlXs :key "C-x-k" :description "Cerrar el buffer")
    (cheatsheet-add :group 'ControlXs :key "C-x C-s" :description "Guardar un archivo")
    (cheatsheet-add :group 'ControlXs :key "C-x-s" :description "Guardar Buffers")
    (cheatsheet-add :group 'ControlXs :key "C-x C-c" :description "Salir de Emacs")
    (cheatsheet-add :group 'ControlXs :key "C-z" :description "Suspende la sesion de Emacs")
    (cheatsheet-add :group 'ControlXs :key "M-x" :description "Abir Comandos")
    (cheatsheet-add :group 'ControlXs :key "C-s" :description "Buscar string (Hacia delante)")
    (cheatsheet-add :group 'ControlXs :key "C-r" :description "Buscar string (Hacia detras)")
    (cheatsheet-add :group 'ControlXs :key "M-%" :description "Reemplazar string")
    (cheatsheet-add :group 'ControlXs :key "C-x-2" :description "Dividir la ventana en 2 (Horizontal)")
    (cheatsheet-add :group 'ControlXs :key "C-x-3" :description "Dividir la ventana en 2 (Vertical)")
    (cheatsheet-add :group 'ControlXs :key "C-x-1" :description "Ventana unica")
    (cheatsheet-add :group 'ControlXs :key "C-x-o" :description "Cambiar el cursor de una ventana a otra")


    :bind ("C-c C-s" . cheatsheet-show))
;; (package-require 'cheatsheet)





;; (global-set-key (kbd "C-c C-s") 'cheatsheet-show)
(provide 'cheatsheet-settings)
