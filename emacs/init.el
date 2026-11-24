;; -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(define-minor-mode write-mode
  "Minor mode for writing."
  :lighter " Write"
  (if write-mode
	  (progn
		(auto-fill-mode 1)
		;; (display-fill-column-indicator-mode 1)
		;; (display-line-numbers-mode 1)
		(hl-line-mode 1)
		(olivetti-mode 1))
	(auto-fill-mode -1)
	;; (display-fill-column-indicator-mode -1)
	;; (display-line-numbers-mode -1)
	(hl-line-mode -1)
	(olivetti-mode -1)))

;;  built-in behavior
(use-package emacs
  :init
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

  ;; show trailing spaces
  (setq-default show-trailing-whitespace t)

  ;; delete to trash
  (setq delete-by-moving-to-trash t)

  ;; backups
  (setq backup-directory-alist
		`((".*" . ,(expand-file-name ".backup/" user-emacs-directory))))
  (setq auto-save-file-name-transforms
		`((".*" ,(expand-file-name ".autosave/" user-emacs-directory) t)))

  ;; theme
  (add-to-list 'custom-theme-load-path
			   (expand-file-name "themes" user-emacs-directory))
  (load-theme 'quiet t))

(use-package simple
  :ensure nil
  :defer nil
  :bind ("C-x x t" . visual-line-mode))

(use-package window
  :ensure nil
  :defer nil
  :bind
  (("C-x 4 k" . kill-buffer-other-window)
   ("C-x 4 1" . delete-other-windows-other-window))
  :config
  (defun kill-buffer-other-window()
	(interactive)
	(kill-buffer (window-buffer (next-window))))
  (defun delete-other-windows-other-window()
	(interactive)
	(other-window 1)
	(delete-other-windows)))

(use-package dired
  :ensure nil
  :defer t
  :config (setq dired-listing-switches "-alh --group-directories-first"))

(use-package hl-line
  :ensure nil
  :defer t
  :hook (prog-mode . hl-line-mode))

(use-package display-line-numbers
  :ensure nil
  :defer t
  :config (setq display-line-numbers-type 'relative)
  :hook (prog-mode . display-line-numbers-mode))

(use-package display-fill-column-indicator
  :ensure nil
  :defer nil
  :config (setq-default fill-column 80)
  :hook (prog-mode . display-fill-column-indicator-mode))

(use-package compile
  :ensure nil
  :defer t
  :init (setq compile-command ""))

(use-package eglot
  :ensure nil
  :init (setq eglot-ignored-server-capabilities
			  '(:documentFormattingProvider
				:documentRangeFormattingProvider
				:documentOnTypeFormattingProvider
				:inlayHintProvider))
  :hook (prog-mode . eglot-ensure))

(use-package which-key
  :ensure nil
  :defer nil
  :init
  (setq which-key-idle-delay 0.25)
  (which-key-mode 1))

(use-package magit
  :defer t)

(use-package ediff
  :init
  (setq ediff-window-setup-function #'ediff-setup-windows-plain))

(use-package hideshow
  :ensure nil
  :hook (prog-mode . hs-minor-mode))

(use-package smex
  :bind (("M-x" . smex))
  :init (smex-initialize))

(use-package org
  :defer t
  :config (setq org-export-backends '(ascii html latex md odt))
  :hook (org-mode . write-mode))

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
  (remove-hook 'olivetti-mode-on-hook 'visual-line-mode)
  (olivetti-set-width (+ fill-column 4)))

(use-package flyspell
  :defer t
  :ensure nil
  :hook (text-mode . flyspell-mode))

(use-package cc-mode
  :defer t
  :config
  (setq c-default-style
		'((java-mode . "java") (awk-mode . "awk") (other . "stroustrup"))))

(use-package multiple-cursors
  :bind (("C-c m m" . mc/edit-lines)
		 ("C-c m a" . mc/edit-beginnings-of-lines)
		 ("C-c m e" . mc/edit-ends-of-lines)
		 ("C-c m n" . mc/mark-next-like-this)
		 ("C-c m p" . mc/mark-previous-like-this)
		 ("C-c m h" . mc/mark-all-like-this))
  :defer t)

(use-package eshell
  :defer t
  :init
  (defun eshell-other-window (&optional arg)
	"Start an eshell buffer in another window."
	(interactive "P")
	(let ((buf (save-window-excursion
				 (eshell (or arg t)))))
	  (switch-to-buffer-other-window buf)))
  (defun eshell/e (&rest paths)
	"Open passed args in a buffer from eshell"
	(dolist (path paths)
	  (find-file path)))
  :bind (("C-x t t" . (lambda (arg)
						(interactive "P")
						(eshell (or arg t))))
		 ("C-x 4 t" . eshell-other-window)))

(use-package eat
  :defer nil
  :init (eat-eshell-mode 1))

(use-package pdf-tools
  :defer nil
  :preface
  (defun office-to-pdf--buffer (source)
	(let* ((source (expand-file-name source))
		   (attrs (file-attributes source))
		   (key (secure-hash
				 'sha256
				 (prin1-to-string
				  (list source
						(file-attribute-modification-time attrs)
						(file-attribute-size attrs)))))
		   (cache-dir (expand-file-name
					   "office-to-pdf"
					   (let ((xdg-cache (getenv "XDG_CACHE_HOME")))
						 (if (and xdg-cache (> (length xdg-cache) 0))
							 xdg-cache
						   (expand-file-name "~/.cache")))))
		   (cached-pdf (expand-file-name (concat key ".pdf") cache-dir)))
	  (unless (file-exists-p cached-pdf)
		(make-directory cache-dir t)
		(let* ((outdir (make-temp-file
						(expand-file-name "convert-" cache-dir) t))
			   (generated-pdf
				(expand-file-name
				 (concat (file-name-base source) ".pdf")
				 outdir))
			   status)
		  (unwind-protect
			  (progn
				(message "Creating PDF for %s..." (file-name-nondirectory source))
				(redisplay t)
				(setq status
					  (call-process "loffice" nil
									"*loffice-pdf-conversion*" nil
									"--convert-to" "pdf"
									"--outdir" outdir
									source))
				(unless (and (integerp status)
							 (zerop status)
							 (file-exists-p generated-pdf))
				  (user-error
				   "PDF conversion failed. See *loffice-pdf-conversion*."))
				(rename-file generated-pdf cached-pdf t))
			(when (file-directory-p outdir)
			  (delete-directory outdir t)))))
	  (let ((buffer (find-file-noselect cached-pdf)))
		(with-current-buffer buffer
		  (setq default-directory (file-name-directory source))
		  (rename-buffer (concat (file-name-base source) ".pdf") t))
		buffer)))
  (defun office-to-pdf--replace-buffer (buffer window)
	(when (buffer-live-p buffer)
	  (let ((pdf-buffer
			 (with-current-buffer buffer
			   (office-to-pdf--buffer buffer-file-name))))
		(if (and (window-live-p window)
				 (eq (window-buffer window) buffer))
			(set-window-buffer window pdf-buffer)
		  (display-buffer pdf-buffer))
		(kill-buffer buffer))))
  :init
  (define-derived-mode office-to-pdf-mode fundamental-mode "Office PDF"
	(run-at-time 0 nil #'office-to-pdf--replace-buffer
				 (current-buffer) (selected-window)))
  (add-to-list 'auto-mode-alist
			   (cons (concat "\\.\\(?:"
							 "odt\\|ods\\|odp\\|"
							 "doc\\|xls\\|ppt\\|"
							 "docx\\|xlsx\\|pptx\\|"
							 "docm\\|xlsm\\|pptm\\|"
							 "rtf"
							 "\\)\\'")
					 'office-to-pdf-mode))
  (defun pdf-view-midnight-match-theme ()
	"Match colors of pdf-tools-midnight-minor-mode to the current theme."
	(interactive)
	(setq-local pdf-view-midnight-colors
				(cons (face-attribute 'default :foreground nil 'default)
					  (face-attribute 'default :background nil 'default)))
	(when (bound-and-true-p pdf-view-midnight-minor-mode)
	  (pdf-view-midnight-minor-mode -1))
	(pdf-view-midnight-minor-mode 1))
  (pdf-tools-install)
  :hook ((pdf-view-mode . pdf-view-roll-minor-mode)
		 (pdf-view-mode . pdf-view-fit-height-to-window)
		 (pdf-view-mode . pdf-view-midnight-match-theme)))
