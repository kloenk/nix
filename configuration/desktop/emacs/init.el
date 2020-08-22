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
