;; packaging
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; minor modes
(define-minor-mode write-mode
  "Minor mode for writing."
  :lighter " Write")

;;  built-in behavior
(use-package emacs
  :init
  ;; set window size
  ;; (if (window-system)
  ;;    (set-frame-size (selected-frame) 90 40))

  ;; disable splash screen / menu bars
  (setq inhibit-startup-screen t)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)

  ;; disable cursor blink
  (blink-cursor-mode 0)

  ;; general indent specification
  (setq-default tab-width 4)

  (setq load-prefer-newer t)

  ;; don't wrap lines
  (setq-default truncate-lines t)

  ;; delete to trash
  (setq delete-by-moving-to-trash t)

  ;; backups
  (setq backup-directory-alist 
		`((".*" . ,(expand-file-name ".backup" user-emacs-directory))))
  (setq auto-save-file-name-transforms
		`((".*" ,(expand-file-name ".autosave" user-emacs-directory) t)))

  ;; theme
  (add-to-list 'custom-theme-load-path 
			   (expand-file-name "themes" user-emacs-directory))
  (load-theme 'quiet t))

(use-package dired
  :ensure nil
  :defer t
  :config
  (setq dired-listing-switches "-alh --group-directories-first"))

(use-package hl-line
  :ensure nil
  :defer t
  :hook ((prog-mode . hl-line-mode)
		 (write-mode . hl-line-mode)))

(use-package display-line-numbers
  :ensure nil
  :defer t
  :config
  (setq display-line-numbers-type 'relative)
  :hook ((prog-mode . display-line-numbers-mode)
		 (write-mode . display-line-numbers-mode)))

(use-package auto-fill
  :ensure nil
  :defer t
  :hook (write-mode . auto-fill-mode))

(use-package display-fill-column-indicator
  :ensure nil
  :defer t
  :config
  (setq-default fill-column 80)
  :hook ((prog-mode . display-fill-column-indicator-mode)
		 (write-mode . display-fill-column-indicator-mode)))

(use-package compile
  :ensure nil
  :defer t
  :config
  (setq compile-command ""))

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo)
  ;; noremap zz za
  (define-key evil-normal-state-map (kbd "z z")
			  #'evil-toggle-fold)
  ;; noremap z. zz
  (define-key evil-normal-state-map (kbd "z .")
			  #'evil-scroll-line-to-center))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; hs-minor-mode for folding
(use-package hideshow
  :ensure nil
  :after evil
  :hook (prog-mode . hs-minor-mode))

(use-package smex
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command))
  :config
  (smex-initialize))

;; org-mode
(use-package org
  :defer t
  :config
  (setq org-export-backends '(ascii html latex md odt))
  :hook (org-mode . write-mode))

;; autoinsert templates
(use-package autoinsert
  :init
  (auto-insert-mode 1)
  (setq auto-insert-query nil
        auto-insert-directory
		(expand-file-name "templates" user-emacs-directory)) 
  :config
  (defun template-placeholder-fill (template)
    (insert-file-contents
     (expand-file-name template auto-insert-directory))
    (let ((fname (file-name-nondirectory (buffer-name)))
          (today (format-time-string "%Y-%m-%d")))
      (goto-char (point-min))
      (while (search-forward "@@FILE@@" nil t)
        (replace-match fname t nil))
      (goto-char (point-min))
      (while (search-forward "@@DATE@@" nil t)
        (replace-match today t nil))))

  (setq auto-insert-alist
        (append
         '((markdown-mode . (lambda ()
                              (template-placeholder-fill "template.md")))
           (org-mode . (lambda ()
                         (template-placeholder-fill "template.org"))))
         auto-insert-alist)))

;; markdown
(use-package markdown-mode
  :defer t
  :hook (markdown-mode . write-mode))

(use-package pandoc-mode
  :defer t
  :hook ((markdown-mode . pandoc-mode)
         (pandoc-mode . pandoc-load-default-settings)))

(use-package olivetti
  :defer t
  :config
  (olivetti-set-width 86)
  :hook ((markdown-mode . olivetti-mode)
         (text-mode . olivetti-mode)))

;; basic text editing
(use-package flyspell
  :defer t
  :ensure nil
  :hook (text-mode . flyspell-mode))

;; c-type langs indent specification
(use-package cc-mode
  :defer t
  :config
  (setq-default c-basic-offset 4))

(use-package vterm
  :config
  (defun term-other-window ()
	"Open term in the other window."
	(interactive)
	(let ((shell (getenv "SHELL"))
		  other)
	  (setq other (if (= 1 (length (window-list)))
					  (if (> (window-width) (* 2 (window-height)))
						  (split-window-right)
						(split-window-below))
					(next-window)))
	  (select-window other)
	  (vterm shell)))
  (define-key ctl-x-4-map (kbd "t") 'term-other-window))

(use-package tidal
  :defer t
  :config
  (defun tidal-start-haskell-hidden ()
	(save-window-excursion
	  (tidal-start-haskell)))
  :hook (tidal-mode . tidal-start-haskell-hidden))

(use-package haskell-mode
  :ensure nil
  :config
  (defun tidal-start-supercollider ()
	(start-process "sclang" "*sclang*" "sclang"))
  :hook (tidal-mode . tidal-start-supercollider))
