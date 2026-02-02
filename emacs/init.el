;; packaging
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;  built-in behavior
(use-package emacs
  :init
  ;; set window size
  (if (window-system)
      (set-frame-size (selected-frame) 90 40))

  ;; disable splash screen / menu bars
  (setq inhibit-startup-screen t)
  (menu-bar-mode 0)
  (tool-bar-mode 0)

  ;; highlight current line
  (global-hl-line-mode 1)

  ;; relative line numbers
  (setq display-line-numbers-type 'relative)
  (global-display-line-numbers-mode 1)

  ;; fill column indicator at 80
  (setq-default fill-column 80)
  (global-display-fill-column-indicator-mode 1)

  ;; follow mode
  (follow-mode 1)

  ;; disable cursor blink
  (blink-cursor-mode 0)

  ;; backups
  (setq backup-directory-alist 
		'(("." . ,(expand-file-name ".backup" user-emacs-directory))))

  ;; theme
  (add-to-list 'custom-theme-load-path 
			   (expand-file-name "themes" user-emacs-directory))
  (load-theme 'quiet t))

;; evil mode
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; smex
(use-package smex
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command))
  :config
  (smex-initialize))

;; autoinsert templates
(use-package autoinsert
  :ensure nil
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
(use-package markdown-mode)

(use-package pandoc-mode
  :hook ((markdown-mode . pandoc-mode)
         (pandoc-mode . pandoc-load-default-settings)))

(use-package olivetti
  :hook ((markdown-mode . olivetti-mode)
         (text-mode . olivetti-mode)))

;; basic text editing
(use-package flyspell
  :ensure nil
  :hook (text-mode . flyspell-mode))
