;;
;; GUI
;;

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 0):

;; Disable cursor blinking
(blink-cursor-mode 0)

;; Disable startup messages
(setq initial-scratch-message "")
(setq inhibit-startup-message t)


;;
;; Packages
;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)


(use-package org
	     :bind (("C-C a" . org-agenda))
	     :init (setq
		    org-agenda-files '("~/src/org/")
		    org-todo-keywords '((sequence
					 "TODO"
					 "IN-PROGRESS"
					 "WAITING"
					 "|"
					 "DONE"
					 "CANCELED"))
		    org-tag-alist '((:startgroup)
				    ("@home" . ?h)
				    ("@office" . ?o)
				    (:endgroup)
				    ("errand" . ?e)
				    ("computer" . ?c)
				    ("phone" . ?p))
		    org-startup-folded 'content
		    org-startup-indented t))

(use-package magit
  :ensure t
  :pin melpa-stable
  :bind (("C-x g" . magit-status)))

(use-package exwm
  :ensure t
  :config
  (require 'exwm-config)
  (exwm-config-default)
  (display-battery-mode 1)
  (setq display-time-default-load-average nil
	display-time-format "%Y-%m-%d %H:%M")
  (display-time-mode t))

(use-package desktop-environment
  :ensure t
  :pin melpa-stable
  :init
  (desktop-environment-mode)
  :config
  (setq desktop-environment-volume-get-command "pulsemixer --get-volume"
	desktop-environment-volume-get-regexp "\\([0-9]+\\)"
	desktop-environment-volume-set-command "pulsemixer --change-colume %s"
	desktop-environment-volume-toggle-command "pulsemixer --toggle-mute"
	desktop-environment-volume-normal-increment "+5"
	desktop-environment-volume-normal-decrement "-5"
	desktop-environment-volume-small-increment "+1"
	desktop-environment-volume-small-decrement "-1"
	desktop-environment-screenshot-directory "~/pic"
	desktop-environment-screenshot-command "maim ~/pic/sc_$(date +'%Y-%m-%d-%H%M%S.png')"
	desktop-environment-screenshot-partial-command "maim -s  ~/pic/sc_$(date +'%Y-%m-%d-%H%M%S.png')"))

(use-package moody
  :ensure t
  :pin melpa-stable
  :config
  (setq x-underline-at-descent-line t
	moody-mode-line-height 20)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (set-face-attribute 'mode-line nil :box nil)
  (set-face-attribute 'mode-line-inactive nil :box nil))

;; store custom UI and package-selected-packages in an untracked file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))
