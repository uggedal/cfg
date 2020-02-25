;;
;; Init settings
;;

(setq gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold (* 1024 1024 100))
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;;
;; Packages
;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)


;;
;; Core
;;

(use-package emacs
  :custom
  (load-prefer-newer t "Prevent loading stale byte code")
  (visible-bell t "Flash frame to represent bell")
  :config
  (fset 'yes-or-no-p 'y-or-n-p))  ;; y/n in stead of yes/no

(use-package simple
  :custom
  (save-interprogram-paste-before-kill
   t
   "Store clipboard text into kill ring before replacement")
  (column-number-mode t "Display column number in mode line")
  :bind ([remap just-one-space] . cycle-spacing))


;;
;; GUI
;;

(use-package emacs
  :custom
  (menu-bar-mode nil)
  (tool-bar-mode nil)
  (initial-scratch-message nil)
  (inhibit-startup-screen t)
  (scroll-conservatively 100000)
  (scroll-preserve-screen-position 1 "Move point when srolling")
  (default-frame-alist '((font . "IBM Plex Mono-10"))))

(use-package scroll-bar
  :custom
  (scroll-bar-mode nil))

(use-package frame
  :custom
  (blink-cursor-mode nil "Disable cursor blinking"))

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward "Results in foo/Makefile bar/Makefile")
  (uniquify-ignore-buffers-re "^\\*" "Ignore special buffers")
  (uniquify-after-kill-buffer-p
   t
   "Rename buffer back after killing matching buffers"))


;;
;; Modeline
;;

(use-package diminish
  :ensure t)


;;
;; History
;;

(use-package saveplace
  :custom
  (save-place-file (concat user-emacs-directory "saveplace")
                   "Keep saved places out of working directories"))

(use-package files
  :config
  (let ((autosave-dir (concat user-emacs-directory
                              "auto-save/")))
    (if (not (file-exists-p autosave-dir))
        (make-directory autosave-dir t))

    (setq auto-save-file-name-transforms
          (append auto-save-file-name-transforms
                  (list (list ".*" autosave-dir t)))))
  :custom
  (backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
                          "Keep backups out of working directories")
  (backup-by-copying t "Use cp and overwrite of original when making backup")
  (version-control t "Make numberic backup versions of edited files")
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2))

(use-package savehist
  :custom
  (savehist-file (concat user-emacs-directory "savehist"))
  (savehist-additional-variables
   '(search-ring regexp-search-ring)
   "Save search entries in addition to minibuffer entries")
  (savehist-autosave-interval 60 "Decrease autosave interval")
  (savehist-mode 1))

(use-package recentf
  :custom
  (recentf-save-file (concat user-emacs-directory "recentf"))
  (recentf-max-saved-items 500)
  (recentf-max-menu-items 15)
  (recentf-auto-cleanup
   'never "Disable auto cleanup since it can cause problems with remote files")
  (recentf-mode 1))

(use-package saveplace
  :custom
  (save-place-file "~/.emacs.d/saveplace")
  (save-place-mode 1))


;;
;; Editor
;;

(use-package emacs
  :custom
  (indent-tabs-mode nil "Indent with spaces as detault")
  (tab-width 8)
  (tab-always-indent
   'complete
   "TAB indents if unindented or completes if already indented")
  (sentence-end-double-space nil))

(use-package files
  :custom
  (require-final-newline t "Add newline at end of file if there isn't one"))

(use-package autorevert
  :custom
  (global-auto-revert-mode t "Auto revert buffers when file change on disk"))

(use-package hippie-expand
  :bind
  ("M-/" . hippie-expand))

(use-package paren
  :custom (show-paren-mode 1))

(use-package whitespace
  :diminish
  :config
  (defun eu/enable-whitespace ()
    (add-hook 'before-save-hook 'whitespace-cleanup nil t)
    (if (derived-mode-p 'org-mode)
        (setq-local whitespace-line-column 200)
      (progn
        (setq-local whitespace-line-column 80)
        (setq-local display-line-numbers t)))
    (whitespace-mode +1)
    (when (derived-mode-p 'makefile-mode)
      (whitespace-toggle-options '(tabs tab-mark))))
  :custom
  (whitespace-style '(face tabs tab-mark empty trailing lines-tail))
  :hook ((text-mode prog-mode conf-mode) . eu/enable-whitespace))

(use-package executable
  :hook (after-save . executable-make-buffer-file-executable-if-script-p))

(use-package diff-hl
  :ensure t
  :pin melpa-stable
  :hook
  (dired-mode . diff-hl-dired-mode)
  (magit-post-refresh . diff-hl-magit-post-refresh)
  :config
  (fringe-mode 8) ;; reset fringe mode to default
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1))


;;
;; Key bindings
;;

(use-package which-key
  :ensure t
  :pin melpa-stable
  :diminish
  :custom
  (which-key-mode t))

(use-package discover-my-major
  :ensure t
  :bind
  ("C-h C-m" . discover-my-major)
  ("C-h M-m" . discover-my-mode))

(use-package guru-mode
  :ensure t
  :diminish
  :custom
  (guru-global-mode 1))


;;
;; Search
;;

(use-package isearch
  :custom
  (isearch-lazy-count t)
  (isearch-yank-on-move t)
  (isearch-allow-scroll 'unlimited))


;;
;; Completion
;;

(use-package icomplete
  :custom
  (icomplete-in-buffer t "Use icomplete in no-mini buffers")
  (icomplete-separator " · ")
  (fido-mode t)
  (icomplete-mode t))


;;
;; Buffer
;;

(use-package ibuffer
  :hook
  (ibuffer-mode . hl-line-mode)
  :custom
  (ibuffer-expert t)
  (ibuffer-display-summary nil)
  :bind ("C-x C-b" . ibuffer))

(use-package ibuffer-vc
  :after ibuffer
  :ensure t
  :init
  (defun ibuffer-set-up-preferred-filters ()
    (ibuffer-vc-set-filter-groups-by-vc-root)
    (unless (eq ibuffer-sorting-mode 'filename/process)
      (ibuffer-do-sort-by-filename/process)))
  (add-hook 'ibuffer-hook 'ibuffer-set-up-preferred-filters)
  :commands ibuffer-vc-set-filter-groups-by-vc-root)

(use-package buffer-move
  :ensure t
  :pin melpa-stable
  :commands (buf-move-up buf-move-down buf-move-left buf-move-right))


;;
;; Extensions
;;

(use-package goto-line-preview
  :ensure t
  :bind ([remap goto-line] . goto-line-preview))

(use-package ediff-wind
  :defer t
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain
                               "Default multiframe breaks EXWM"))

(use-package vc-hooks
  :custom (vc-follow-symlinks t "Follow symlink to vc file without asking"))

(use-package dired
  :hook
  (dired-mode . hl-line-mode)
  :custom
  (dired-listing-switches "-alh"))

(use-package dired-x
  :after dired
  :bind (("C-x C-j" . dired-jump)
          ("C-x 4 C-j" . dired-jump-other-window)))

(use-package magit
  :ensure t
  :bind
  ("C-x g" . magit-status)
  ("C-c g" . magit-file-dispatch))

(use-package tramp
  :custom
  (tramp-default-method "ssh"))


;;
;; Languages
;;

(use-package flycheck
  :ensure t
  :custom
  (flycheck-check-syntax-automatically
   '(save mode-enabled) "Check only when opening buffer and saving buffer")
  :hook (prog-mode . flycheck-mode))

(use-package make-mode
  :ensure nil
  :defer t
  :hook (makefile-mode . (lambda () (setq indent-tabs-mode t))))

(use-package yaml-mode
  :ensure t
  :pin melpa-stable
  :mode ("\\.yml$" . yaml-mode)
  :hook (yaml-mode . subword-mode)) ;; yaml-mode derives from text-mode

(use-package prog-mode
  :ensure nil
  :hook (prog-mode . subword-mode))

;; Disable saving of elisp buffer is parens are unmatched:
(use-package elisp-mode
  :ensure nil
  :config
  (add-hook 'emacs-lisp-mode-hook
   (function (lambda ()
               (add-hook 'local-write-file-hooks 'check-parens)))))

(use-package gitignore-mode
  :ensure t
  :defer t
  :pin melpa-stable)

(use-package org
  :bind (("C-C a" . org-agenda))
  :custom
  (org-agenda-files '("~/src/org/"))
  (org-todo-keywords '((sequence
                        "TODO"
                        "IN-PROGRESS"
                        "WAITING"
                        "|"
                        "DONE"
                        "CANCELED")))
  (org-tag-alist '((:startgroup)
                   ("@home" . ?h)
                   ("@office" . ?o)
                   (:endgroup)
                   ("errand" . ?e)
                   ("computer" . ?c)
                   ("phone" . ?p)))
  (org-startup-folded 'content))


;;
;; Window manager
;;

(defun eu/xrandr-toggle (arg)
  "Toggle between xrandr screens.
ARG internal, external or both"
  (call-process (expand-file-name "~/.local/bin/xrandr-toggle")
                nil nil nil arg))

(use-package exwm
  :ensure t
  :custom
  (exwm-randr-workspace-monitor-plist
   '(0 "DP-1" 2 "DP-1" 3 "DP-1" 4 "DP-1" 5 "DP-1")
   "Workspace to monitor mapping")
  (exwm-workspace-number 1 "Number of initial workspaces")
  (exwm-input-simulation-keys
   '(([?\C-b] . [left])
     ([?\C-f] . [right])
     ([?\C-p] . [up])
     ([?\C-n] . [down])
     ([?\C-a] . [home])
     ([?\C-e] . [end])
     ([?\M-v] . [prior])
     ([?\C-v] . [next])
     ([?\C-d] . [delete])
     ([?\C-k] . [S-end delete]))
   "Line-editing shortcuts")
  (exwm-input-global-keys
   `(
     ;; Toggle between char and line mode:
     ([?\s-i] . exwm-input-toggle-keyboard)
     ;; Move point from window to window:
     ([?\s-p] . windmove-up)
     ([?\s-n] . windmove-down)
     ([?\s-b] . windmove-left)
     ([?\s-f] . windmove-right)
     ([?\s-P] . buf-move-up)
     ([?\s-N] . buf-move-down)
     ([?\s-B] . buf-move-left)
     ([?\s-F] . buf-move-right)
     ;; Launch appliction:
     ([?\s-r]
      . (lambda (command)
          (interactive (list (read-shell-command "$ ")))
          (start-process-shell-command command nil command)))
     ;; Launch ansi-term with bash:
     ,`(,(kbd "<S-s-return>")
        . (lambda ()
            (interactive)
            (start-process-shell-command "xterm" nil "xterm")))
     ;; Switch to external display:
     ,`(,(kbd "<XF86Display>")
        . (lambda ()
            (interactive)
            (eu/xrandr-toggle "external")))
     ;; Switch to internal display:
     ,`(,(kbd "M-<XF86Display>")
        . (lambda ()
            (interactive)
            (eu/xrandr-toggle "internal")))
     ;; Switch to internal and external display:
     ,`(,(kbd "C-<XF86Display>")
        . (lambda ()
            (interactive)
            (eu/xrandr-toggle "both")))
     ;; Audio mute:
     ,`(,(kbd "<XF86AudioMute>")
        . (lambda ()
            (interactive)
            (start-process-shell-command
             "pactl" nil
             "pactl set-sink-mute @DEFAULT_SINK@ toggle")))
     ;; Audio raise volume:
     ,`(,(kbd "<XF86AudioRaiseVolume>")
        . (lambda ()
            (interactive)
            (start-process-shell-command
             "pactl" nil
             "pactl set-sink-volume @DEFAULT_SINK@ +5%")))
     ;; Audio lower volume:
     ,`(,(kbd "<XF86AudioLowerVolume>")
        . (lambda ()
            (interactive)
            (start-process-shell-command
             "pactl" nil
             "pactl set-sink-volume @DEFAULT_SINK@ -5%")))
     ;; Switch to certain workspace N:
     ,@(mapcar (lambda (i)
                 `(,(kbd (format "s-%d" i)) .
                   (lambda ()
                     (interactive)
                     (exwm-workspace-switch-create ,i))))
               (number-sequence 1 9))))
  :hook
  (exwm-update-class . (lambda ()
                         (exwm-workspace-rename-buffer exwm-class-name)))
  :config
  (require 'exwm-randr)
  (exwm-randr-enable)
  (exwm-enable)

  (eu/xrandr-toggle "internal")

  (setq window-divider-default-bottom-width 2
        window-divider-default-right-width 2)
  (window-divider-mode))


;;
;; Customization
;;

(use-package cus-edit
  :custom
  (custom-file (expand-file-name "custom.el" user-emacs-directory))
  :init
  (when (file-exists-p custom-file)
    (load custom-file)))

;;
;; Reset init settings
;;

(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original)
   (setq file-name-handler-alist file-name-handler-alist-original)
   (makunbound 'gc-cons-threshold-original)
   (makunbound 'file-name-handler-alist-original)))
