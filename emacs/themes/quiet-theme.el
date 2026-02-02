(deftheme quiet "Plain theme without syntax highlighting.")

(defgroup quiet-theme nil
  "Plain theme colors and faces."
  :group 'faces
  :prefix "quiet-")

(defcustom quiet-background "black"
  "Color to use for background."
  :type 'color)

(defcustom quiet-foreground "white"
  "Color to use for text."
  :type 'color)

(defcustom quiet-comment "grey"
  "Color to use for comments."
  :type 'color)

(defcustom quiet-highlight "dimgray"
  "Color to use for highlight."
  :type 'color)

(defcustom quiet-link "violet"
  "Color to use for hyperlinks."
  :type 'color)

(defcustom quiet-link-visited "lightcoral"
  "Color to use for visited hyperlinks."
  :type 'color)

(defcustom quiet-mode-line "black"
  "Color to use for mode-line."
  :type 'color)

(defcustom quiet-faces '(default eshell-prompt fringe minibuffer-prompt)
  "List of faces to decolorize."
  :type '(repeat symbol))

(defun quiet--spec (face)
  "Return spec for a FACE."
  `(,face ((t (:background ,quiet-background :foreground ,quiet-foreground)))))

(defun quiet--add (faces)
  "Add FACES to the theme definition."
  (apply 'custom-theme-set-faces 'quiet (mapcar 'quiet--spec faces)))

(quiet--add quiet-faces)

;; Comments should be grey
(custom-theme-set-faces
  'quiet
  `(font-lock-comment-face
     ((t (:foreground ,quiet-comment))))
  `(font-lock-comment-delimiter-face
     ((t (:foreground ,quiet-comment))))
  `(hl-line
    ((t (:background ,quiet-highlight))))
  `(link
    ((t (:foreground ,quiet-link))))
  `(link-visited
    ((t (:foreground ,quiet-link-visited))))
  `(mode-line
    ((t (:background ,quiet-mode-line))))
  `(mode-line-inactive
    ((t (:background ,quiet-mode-line)))))


(defcustom quiet-prefix-alist
  '((font-lock . "font-lock-")
    (sh-script . "sh-")
    (web-mode . "web-mode-"))
  "Mapping from files to face prefixes: when file is first loaded,
decolorizes every face that starts with the prefix."
  :type '(alist :key-type symbol :value-type string))

(require 'cl-lib)

(defun quiet--prefix (prefix)
  "Return all faces that start with PREFIX."
  (cl-remove-if-not (lambda (s) (string-prefix-p prefix (symbol-name s)))
		    (face-list)))

(dolist (a quiet-prefix-alist)
  (eval-after-load (car a) `(quiet--add (quiet--prefix ,(cdr a)))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'quiet)
