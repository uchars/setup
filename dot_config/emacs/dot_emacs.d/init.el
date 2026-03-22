;;; init.el --- Personal emacs config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Works on my machine (tm)
;;; Author: Nils Sterz
;;; Code:
(setq gc-cons-threshold #x40000000)

;(setq url-proxy-services '(("http" . "user%40mail:password@proxy:8080")
;                           ("https" . "user%40mail:password@proxy:8080")))

(setq read-process-output-max (* 1024 1024 4))
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(setq use-package-always-ensure t)

(defvar n/tramp-hosts
      '(("sterz_n@juniper" . "/ssh:sterz_n@10.42.42.10:")))

(defun n/choose-tramp()
  "Choose tramp host to connect to."
  (interactive)
  (let ((host (completing-read "Choose a host: " n/tramp-hosts)))
	(find-file (concat (cdr (assoc host n/tramp-hosts)) "/"))))

(defun n/transparency-enable ()
  "Enables Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(80 . 80))
  (add-to-list 'default-frame-alist '(alpha . (80 . 80))))

(defun n/transparency-disable ()
  "Disable Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(100 . 100))
  (add-to-list 'default-frame-alist '(alpha . (100 . 100))))

(defun n/search-ddg ()
  "Search DuckDuckGo for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?q=" q))))

(defun n/search-google ()
  "Search Google for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://google.com/search?q=" q))))

(defun n/search-wiki ()
  "Search wikipedia for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://wikipedia.org/wiki/" q))))

(defun n/search-cpp ()
  "Search wikipedia for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?sites=cppreference.com&q=" q))))

(defun n/search-stackoverflow ()
  "Search StackOverflow for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?sites=stackoverflow.com&q=" q))))

(use-package emacs
  :ensure nil
  :custom
  (column-number-mode t)
  (auto-save-default nil)
  (create-lockfiles nil)
  (delete-by-moving-to-trash t)
  (display-line-numbers-type 'relative)
  (history-length 42)
  (inhibit-startup-message t)
  (ispell-dictionary "en_US")
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (split-width-threshold 300)
  (tab-width 4)
  (truncate-lines t)
  (use-dialog-box nil)
  (warning-minimum-level :emergency)
  :hook
  (prog-mode . display-line-numbers-mode)
  :config
  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)
  (global-set-key (kbd "<escape>")      'keyboard-escape-quit)
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font"  :height 140)
  (setq scroll-margin 8)
  (setq scroll-conservatively 100)
  (setq use-short-answers t)
  (setq global-hl-line-mode nil)
  (add-to-list 'load-path "~/.emacs.d/custom")
  (load-theme 'modus-vivendi :no-confirm)
  (fset #'jsonrpc--log-event #'ignore)
  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?|))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (setq tramp-default-method "ssh")
  (setq tramp-verbose 1)
  ;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (setq tramp-default-method "ssh")
  (setq image-animate-speed-alist '((gif . 0.1)))
  (setq image-use-external-converter t)
  (setq auto-save-file-name-transforms
		`((".*" "~/.emacs-saves/" t)))
  (setq backup-directory-alist `(("." . "~/.saves")))
  (add-to-list
   'display-buffer-alist
   '("\\*compilation\\*"
     (display-buffer-no-window)))
  (when (eq window-system 'w32)
	(setq tramp-default-method "plink")
	(when (and (not (string-match putty-directory (getenv "PATH")))
			   (file-directory-p putty-directory))
	  (setenv "PATH" (concat putty-directory ";" (getenv "PATH")))
	  (add-to-list 'exec-path putty-directory)))
  (ignore-errors
    (require 'ansi-color)
    (defun my-colorize-compilation-buffer ()
      (when (eq major-mode 'compilation-mode)
        (ansi-color-apply-on-region compilation-filter-start (point-max))))
    (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))
  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (add-hook 'after-init-hook
    (lambda ()
      (with-current-buffer (get-buffer-create "*scratch*")
        (insert (format
                 ";; Loading (%s) Packages(%s)"
                  (emacs-init-time)
                  (number-to-string (length package-activated-list)))))))
  (when scroll-bar-mode (scroll-bar-mode -1))
  (save-place-mode 1)
  (savehist-mode 1)
  (indent-tabs-mode -1)
  (global-hl-line-mode 1)
  (add-hook 'text-mode-hook 'display-line-numbers-mode)
  (modify-coding-system-alist 'file "" 'utf-8))

(use-package dired
  :ensure nil
  :after evil
  :custom
  (setq dired-compress-files-alist
    '(("\\.tar\\.gz\\'" . "tar -c %i | gzip -c9 > %o")
      ("\\.zip\\'" . "zip %o -r --filesync %i")))
  (dired-listing-switches "-lah --group-directories-first")
  (dired-guess-shell-alist-user
   '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open" "open")
     ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open" "open")
     (".*" "open" "xdg-open")))
  (dired-kill-when-opening-new-dired-buffer t)
  :config
  (setq dired-mode-map (make-keymap))
  (evil-set-initial-state 'dired-mode 'motion)
  (evil-define-key 'motion dired-mode-map
    (kbd "RET") 'dired-find-file
    (kbd "j") 'dired-next-line
    (kbd "k") 'dired-previous-line
    (kbd "D") 'dired-do-delete
    (kbd "O") 'dired-do-open
    (kbd "-") 'dired-up-directory
    (kbd "q") 'quit-window
    (kbd "=") 'dired-diff
    (kbd "mm") 'dired-mark
    (kbd "mu") 'dired-unmark
    (kbd "mU") 'dired-unmark-all-marks
	(kbd "<leader> SPC") 'counsel-switch-buffer
    (kbd "d !") 'dired-do-shell-command
    (kbd "R") 'dired-do-rename
    (kbd "S") 'dired-do-search
    (kbd "%") 'dired-create-empty-file
    (kbd "^") 'dired-create-directory
    (kbd "C") 'dired-do-copy
    (kbd "Z") 'dired-do-compress-to))


(unless (eq system-type 'windows-nt)
  (use-package exec-path-from-shell
    :ensure t
    :init
    (exec-path-from-shell-initialize)))

(use-package ivy
  :ensure t
  :after evil
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'swiper)
  (evil-define-key 'normal ivy-mode-map (kbd "C-j") 'ivy-next-line)
  (evil-define-key 'normal ivy-mode-map (kbd "C-k") 'ivy-previous-line)
  (ivy-mode))

(use-package vertico
  :ensure t
  :hook
  (after-init . vertico-mode)
  :custom
  (vertico-count 10)
  (vertico-resize nil)
  (vertico-cycle nil))

(use-package counsel
  :ensure t
  :after ivy
  :config
  :bind (("M-x" . counsel-M-x)
		 ("C-h k" . counsel-descbinds)
         ("C-h f" . counsel-describe-function)))

(use-package orderless
  :ensure t
  :defer t
  :after vertico
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :hook
  (after-init . marginalia-mode))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

(use-package diff-hl
  :defer t
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)
                 (diff-hl-flydiff-mode)
                 (diff-hl-margin-mode))))

(use-package magit
  :ensure t
  :after evil
  :config
  (setq magit-mode-map (make-keymap)
        magit-status-mode-map (make-keymap)
        magit-diff-mode-map (make-keymap)
       magit-stashes-mode-map (make-keymap))
  (evil-define-key 'motion 'global (kbd "<leader> g s") 'magit)
  (evil-define-key 'motion 'global (kbd "<leader> g l") 'magit-log-current)
  (evil-define-key 'normal magit-mode-map
    (kbd "RET") #'magit-visit-thing
    (kbd "TAB") #'magit-section-cycle
    (kbd "=") #'magit-section-cycle
    (kbd "R") #'magit-refresh
    (kbd "s") #'magit-stage
    (kbd "u") #'magit-unstage
    (kbd "x") #'magit-discard
    (kbd "c c") #'magit-commit
    (kbd "c a") #'magit-commit-amend
    (kbd "r r") #'magit-rebase
    (kbd "P") #'magit-push
  ))

(use-package magit-todos
  :ensure t
  :defer t
  :after magit
  :config (magit-todos-mode 1))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package xclip
  :ensure t
  :defer t
  :hook
  (after-init . xclip-mode))

(use-package markdown-mode
  :ensure t
  :mode ("\\.md" . markdown-view-mode)
  :config
  (setq markdown-command "marked")
  (defun dw/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 2.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))
  (defun dw/markdown-mode-hook ()
    (dw/set-markdown-header-font-sizes))
  (add-hook 'markdown-mode-hook 'dw/markdown-mode-hook))

(use-package company-box
  :diminish
  :hook (company-mode . company-box-mode)
  :custom
  (company-box-scrollbar nil))

(use-package undo-tree
  :defer t
  :ensure t
  :hook
  (after-init . global-undo-tree-mode)
  :init
  (setq undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t
        undo-limit 800000
        undo-strong-limit 12000000)
  :config
  (evil-define-key 'normal 'global (kbd "<leader> u") 'undo-tree-visualize)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.cache/undo"))))

(use-package lsp-mode
  :ensure t
  :hook
  (java-ts-mode . lsp)
  :custom
  (lsp-idle-delay 0.5)
  (lsp-log-io nil)
  (lsp-lens-enable t)
  (lsp-prefer-flymake nil)
  (lsp-enable-snippet t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-eldoc-render-all t)
  (lsp-headerline-breadcrumb-enable nil)
  :config
  (defun n/lsp-setup ()
	(evil-define-key 'normal prog-mode-map
	  (kbd "<leader> c a") 'lsp-execute-code-action
	  (kbd "g d") 'lsp-find-definition
	  (kbd "<leader> g r") 'lsp-find-references
	  (kbd "<leader> f m") 'lsp-format-buffer
	  (kbd "<leader> f r") 'lsp-format-region
	  (kbd "<leader> r n") 'lsp-rename)
    (setq-local eldoc-display-functions '(eldoc-display-in-buffer)))
  (add-hook 'lsp-mode-hook #'n/lsp-setup))

(use-package lsp-ui
  :ensure t
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-doc-delay 0)
  (lsp-ui-doc-use-childframe t)
  ;; (lsp-ui-doc-alignment 'frame)
  (lsp-ui-doc-alignment 'window)
  (lsp-ui-doc-position 'bottom)
  ;; (lsp-ui-doc-position 'top)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-flycheck-live-reporting nil)
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (ef-themes-with-colors
    (set-face-attribute 'lsp-ui-doc-background nil :background bg-main)))

(use-package lsp-java
  :after lsp)

;; (use-package eglot
;;   :ensure t
;;   :hook (prog-mode . eglot-ensure)
;;   :config
;;   (evil-define-key 'normal eglot-mode-map (kbd "g r") 'xref-find-references)
;;   (evil-define-key 'normal eglot-mode-map (kbd "g d") 'xref-find-definitions)
;;   (evil-define-key 'normal eglot-mode-map (kbd "<leader> c a") 'eglot-code-actions)
;;   (evil-define-key 'normal eglot-mode-map (kbd "<leader> r n") 'eglot-rename)
;;   (evil-define-key 'normal eglot-mode-map (kbd "<leader> f m") 'eglot-format-buffer)
;;   (setq eglot-autoshutdown t)
;;   (setq eglot-send-changes-idle-time 0.1)
;;   (setq eglot-ignored-server-capabilities '(:documentHighlightProvider))
;;   (setq eglot-connect-timeout 10)
;;   (setq eglot-sync-connect 1)
;;   (setq eglot-events-buffer-size 0)
;;   (add-to-list 'eglot-server-programs '(python-ts-mode . ("pylsp"))))

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package nerd-icons
  :ensure t
  :defer t)

(use-package nerd-icons-dired
  :ensure t
  :defer t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :ensure t
  :after (:all nerd-icons marginalia)
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(defun n/evil-scroll-up ()
  "Center page after scroll."
  (interactive)
  (evil-scroll-up nil)
  (evil-scroll-line-to-center nil))

(defun n/evil-scroll-down ()
  "Center page after scroll."
  (interactive)
  (evil-scroll-down nil)
  (evil-scroll-line-to-center nil))

(use-package haskell-mode
  :ensure t
  :defer t)

(use-package company
  :ensure t
  :hook
  (after-init . global-company-mode))

(use-package lsp-haskell
  :ensure t
  :defer t
  :config
  (setq lsp-haskell-server-path "~/.ghcup/bin/haskell-language-server-wrapper"))

(use-package cargo
  :ensure t
  :defer t)

(use-package cmake-mode
  :mode ("CMakeLists\\.txt" "\\.cmake"))

(use-package projectile
  :ensure t
  :custom ((projectile-completion-system 'ivy))
  :config
  (setq projectile-project-search-path '("~/.files" "~/projects/" "~/work/"))
  (setq projectile-switch-project-action #'projectile-dired)
  (evil-define-key 'normal 'global (kbd "C-p") 'project-find-file)
  (evil-define-key 'motion 'global (kbd "C-p") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p d") 'project-dired)
  (evil-define-key 'normal 'global (kbd "<leader> p s") 'project-eshell)
  (evil-define-key 'motion 'global (kbd "<leader> p s") 'project-eshell)
  (evil-define-key 'normal 'global (kbd "<leader> p b") 'project-switch-to-buffer)
  (evil-define-key 'motion 'global (kbd "<leader> p p") 'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  (evil-define-key 'motion 'global (kbd "<leader> p f") 'project-find-file)
  :hook
  (after-init . projectile-mode))

(use-package ripgrep
  :ensure t
  :after projectile)

(use-package mood-line
  :ensure t
  :config
  (mood-line-mode))

(use-package harpoon
  :ensure t
  :after evil
  :config
  (evil-define-key 'normal 'global
	(kbd "<leader> 1") 'harpoon-go-to-1
	(kbd "<leader> 2") 'harpoon-go-to-2
	(kbd "<leader> 3") 'harpoon-go-to-3
	(kbd "<leader> 4") 'harpoon-go-to-4
	(kbd "<leader> m") 'harpoon-add-file
	(kbd "<leader> h l") 'harpoon-quick-menu-hydra
	(kbd "<leader> d 1") 'harpoon-delete-1
	(kbd "<leader> d 2") 'harpoon-delete-2
	(kbd "<leader> d 3") 'harpoon-delete-3))

(defun nils/org-mode-setup ()
  "Setting up org mode."
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 0)
  (setq evil-auto-indent nil))

(use-package org
  :ensure t
  :defer t
  :hook (org-mode . nils/org-mode-setup)
  :custom
  (org-directory "~/Documents")
  (org-default-notes-file "~/Documents/tmp.org")
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t
	org-src-fontify-natively t
	org-fontify-quote-and-verse-blocks t
	org-src-tab-acts-natively t
	org-edit-src-content-indentation 2
	org-hide-block-startup nil
	org-src-preserve-indentation nil
	org-startup-folded 'content
	org-cycle-separator-lines 2)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
  (set-face-attribute 'org-document-title nil :weight 'bold :height 1.3)
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'medium :height (cdr face)))
  (require 'org-indent))

(use-package evil-org
  :ensure t
  :after org
  :hook ((org-mode . evil-org-mode)
		 (org-agenda-mode . evil-org-mode)
		 (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/notes")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t)
     ("b" "dienstreise" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n#+filetags: Dienstreise")
      :unnarrowed t)))
   :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(use-package org-roam-ui
  :ensure t
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t))

(use-package nix-mode
  :mode "\\.nix")

(use-package evil
  :ensure t
  :hook
  (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-set-undo-system 'undo-tree)
  (setq evil-leader/in-all-states t)
  (setq evil-want-fine-undo t)

  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  (setq evil-emacs-state-modes '())
  (evil-set-initial-state 'term-mode 'insert)
  (evil-set-initial-state 'image-mode 'motion)
  (evil-set-initial-state 'special-mode 'motion)
  (evil-set-initial-state 'eww-mode 'motion)
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-set-initial-state 'org-agenda-mode 'motion)
  (evil-set-initial-state 'compilation-mode 'normal)
  (evil-set-initial-state 'grep-mode 'motion)
  (evil-set-initial-state 'Info-mode 'motion)
  (evil-set-initial-state 'dired-mode 'motion)
  (evil-set-initial-state 'magit-status-mode 'normal)
  (evil-set-initial-state 'magit-diff-mode 'normal)
  (evil-set-initial-state 'magit-stashes-mode 'normal)
  (evil-set-initial-state 'epa-key-list-mode 'motion)
  (evil-set-initial-state 'fuel-debug-mode 'motion)
  (evil-set-initial-state 'xref--xref-buffer-mode 'motion)

  (evil-define-key 'normal 'global (kbd "<leader> s s") 'hydra-search/body)
  (evil-define-key 'normal 'global (kbd "C-u") 'n/evil-scroll-up)
  (evil-define-key 'normal 'global (kbd "C-d") 'n/evil-scroll-down)
  (evil-define-key 'normal 'global (kbd "<leader> c c") 'project-compile)
  (evil-define-key 'normal 'global (kbd "<leader> c e") 'compile-goto-error)
  (evil-define-key 'normal 'global (kbd "<leader> r c") 'recompile)
  (evil-define-key 'normal 'global (kbd "<leader> !") 'shell-command)
  (evil-define-key 'motion 'global (kbd "<leader> !") 'shell-command)
  (evil-define-key 'normal xref--xref-buffer-mode-map (kbd "<return>") 'xref-goto-xref)
  (evil-define-key 'motion xref--xref-buffer-mode-map (kbd "<return>") 'xref-goto-xref)
  (evil-define-key 'motion xref--xref-buffer-mode-map (kbd "C-<return>") 'xref-goto-xref)
  (evil-define-key 'motion eww-mode-map (kbd "C-o") 'eww-back-url)
  (evil-define-key 'motion eww-mode-map (kbd "C-i") 'eww-forward-url)
  (evil-define-key 'normal emacs-lisp-mode-map (kbd "<leader> i") 'eval-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> t c") 'n/choose-tramp)
  (evil-define-key 'normal 'global (kbd "C-b") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> z z") 'hydra-zoom/body)
  (evil-define-key 'normal 'global (kbd "<leader> o") 'hydra-org/body)
  (evil-define-key 'normal 'motion (kbd "C-b") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> SPC") 'counsel-switch-buffer)
  (evil-define-key 'motion 'global (kbd "<leader> SPC") 'counsel-switch-buffer))

(use-package flycheck
  :ensure t
  :after evil
  :config
  (evil-define-key 'normal prog-mode-map (kbd "[ e") 'flycheck-previous-error)
  (evil-define-key 'normal prog-mode-map (kbd "] e") 'flycheck-next-error))

(use-package evil-commentary
  :ensure t
  :defer t
  :init
  (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-matchit
  :ensure t
  :after evil
  :config
  (global-evil-matchit-mode 1))

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-org ()
    "org"
    ("i" org-roam-node-insert "insert")
    ("f" org-roam-node-find "find/create")
    ("c" org-roam-node-capture "capture")
    ("v" org-roam-node-visit "visit")
    ("u" org-roam-ui-open "open ui"))
  (defhydra hydra-search ()
    "search"
    ("d" n/search-ddg "duckduckgo")
    ("c" n/search-cpp "c++ wiki")
    ("s" n/search-stackoverflow "stackoverflow")
    ("w" n/search-wiki "wikipedia"))
  (defhydra hydra-zoom ()
    "zoom"
    ("+" text-scale-increase "in")
    ("0" text-scale-set "reset")
    ("-" text-scale-decrease "out")))

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf" . pdf-view-mode)
  :after evil
  :hook
  (pdf-view-mode . (lambda () (internal-show-cursor nil nil)))
  (pdf-view-themed-minor-mode . (lambda () (internal-show-cursor nil nil)))
  :config
  (define-key pdf-view-mode-map (kbd "q") nil)
  (add-to-list 'display-buffer-alist
			   '((derived-mode . pdf-view-mode)
				 (display-buffer-in-side-window)
				 (side . right)
				 (window-width . 80)))
  (evil-define-key 'normal pdf-view-mode-map
    "h" 'scroll-left
    "l" 'scroll-right
    "j" 'pdf-view-scroll-up-or-next-page
    "k" 'pdf-view-scroll-down-or-previous-page
    "r" (lambda() (interactive) (pdf-view-rotate 90))
    "R" (lambda() (interactive) (pdf-view-rotate -90))
    (kbd "C-d") 'pdf-view-next-page
    (kbd "C-u") 'pdf-view-previous-page
    (kbd "f p") 'pdf-view-fit-page-to-window
    (kbd "f w") 'pdf-view-fit-width-to-window
    (kbd "t d") 'pdf-view-themed-minor-mode
    "]" 'pdf-view-next-page-command
    "[" 'pdf-view-previous-page-command
    "-" 'pdf-view-shrink
    "+" 'pdf-view-enlarge))

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  :config (progn
			(setq TeX-source-correlate-mode t)
			(setq TeX-source-correlate-method 'synctex)
			(require 'reftex)
			(setq reftex-plug-into-AUCTeX t)
			(require 'auctex-latexmk)
			(auctex-latexmk-setup)
			(pdf-tools-install)
			(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
				  TeX-source-correlate-start-server t)
			;; Update PDF buffers after successful LaTeX runs
			(add-hook 'TeX-after-compilation-finished-functions
					  #'TeX-revert-document-buffer)
			(add-hook 'LaTeX-mode-hook
					  (lambda ()
						(reftex-mode t)
						(flyspell-mode t)))
			))

(provide 'init)
;;; init.el ends here
