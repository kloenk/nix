(require 'package)

;; optional. makes unpure packages archives unavailable
(setq package-archives nil)

(setq package-enable-at-startup nil)
(package-initialize)

;; Enable Evil
(require 'evil)
(evil-mode 1)


(require 'doom-modeline)
(doom-modeline-mode 1)

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(require 'ccls)
(setq ccls-executable "/run/current-system/sw/bin/ccls") ;; TODO: use substituteAll

;; company enable
(add-hook 'after-init-hook 'global-company-mode)

;; Disable some GUI distractions.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode 0)

;; Stop creating backup and autosave files.
(setq make-backup-files nil
    auto-save-default nil)

;; Always show line and column number in the mode line.
(line-number-mode)
(column-number-mode)


