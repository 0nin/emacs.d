(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us")
(load-file "~/.emacs.d/ergoemacs/site-lisp/site-start.el")

;; Add comment according major mode
(global-set-key (kbd "M-/") 'comment-dwim)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;; (add-to-list 'auto-mode-alist '("\\.mmf\\'" . asm-mode))
(setq w32-pipe-read-delay 0)

;; (package-initialize)
(add-to-list 'load-path "~/.emacs.d/custom")
(add-to-list 'load-path "~/.emacs.d/3rd")

(defun custom-package ()
  (package-initialize)

  (require 'cl)
  (defvar required-packages
    '(company
      company-c-headers
      company-irony
      auto-complete
      auto-complete-c-headers
      flycheck
      flycheck-irony
      ggtags
      yasnippet
      sr-speedbar
      iedit
      elscreen
      ecb
      eide
      org
      color-theme
      nyan-mode 
      flymake-google-cpplint
      google-c-style
      arduino-mode
      multiple-cursors))

  (defun packages-installed-p ()
    "Packages availability checking."
    (interactive)
    (loop for package in required-packages
          unless (package-installed-p package)
          do (return nil)
          finally (return t)))

  ;; Auto-install packages
  (unless (packages-installed-p)
    (message "%s" "Emacs is now refreshing it's package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    (dolist (package required-packages)
      (unless (package-installed-p package)
        (package-install package))))
;;  (return t)
  )


(defun custom-global ()
  ;; Display file size/time in mode-line
  (setq display-time-24hr-format t) 
  (display-time-mode             t) 
  (size-indication-mode          t) 

  ;; Clipboard settings
  (setq x-select-enable-clipboard t)

  (setq use-dialog-box     nil) 
  (setq redisplay-dont-pause t) 

  ;; Disable backup/autosave files
  (setq make-backup-files        nil)
  (setq auto-save-default        nil)

  (setq use-dialog-box     nil) 
  (setq redisplay-dont-pause t)
  (setq ring-bell-function 'ignore)

  (setq speedbar-show-unknown-files t) ; show all files
  (setq sr-speedbar-right-side nil) ; put on left side
  (setq speedbar-use-images nil) ; use text for buttons
  ;; (setq sr-speedbar-auto-refresh nil)

  ;; Display the name of the current buffer in the title bar
  (setq frame-title-format "GNU Emacs: %b")

  ;; Show-paren-mode settings
  (show-paren-mode t) ;; {},[],()
  (setq show-paren-style 'expression) ;; {},[],()

  ;; IDO plugin
  (require 'ido)
  (ido-mode                      t)
  (icomplete-mode                t)
  (ido-everywhere                t)
  (setq ido-vitrual-buffers      t)
  (setq ido-enable-flex-matching t)
  )

(defun custom-bookmark ()
  ;; (require 'bookmark)
  ;; (setq bookmark-save-flag t) ;; автоматически сохранять закладки в файл
  ;; (when (file-exists-p (concat user-emacs-directory "bookmarks"))
  ;;   (bookmark-load bookmark-default-file t)) ;; попытаться найти и открыть файл с закладками
  ;; (global-set-key (kbd "<f3>") 'bookmark-set) ;; создать закладку по F3 
  ;; (global-set-key (kbd "<f4>") 'bookmark-jump) ;; прыгнуть на закладку по F4
  ;; (global-set-key (kbd "<f5>") 'bookmark-bmenu-list) ;; открыть список закладок
  ;; (setq bookmark-default-file (concat user-emacs-directory "bookmarks")) ;; хранить закладки в файл bookmarks в .emacs.d
  )

(defun custom-ggtags ()
  (require 'ggtags)
  ;; (add-hook 'c-mode-common-hook
  ;;           (lambda ()
  ;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
  ;;               (ggtags-mode 1))))

  (ggtags-mode 1)

  (define-key ggtags-mode-map (kbd "C-c s") 'ggtags-find-other-symbol)
  (define-key ggtags-mode-map (kbd "C-c h") 'ggtags-view-tag-history)
  (define-key ggtags-mode-map (kbd "C-c r") 'ggtags-find-reference)
  (define-key ggtags-mode-map (kbd "C-c f") 'ggtags-find-file)
  (define-key ggtags-mode-map (kbd "C-c c") 'ggtags-create-tags)
  (define-key ggtags-mode-map (kbd "C-c u") 'ggtags-update-tags)


  (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
  ;; (ggtags-mode)
  )

(defun custom-company ()
  ;; (require 'company)
  (require 'company-gtags)
  (require 'company-semantic)
  (require 'company-yasnippet)
  ;; (add-hook 'after-init-hook 'global-company-mode)
  ;; (add-hook 'after-init-hook 'global-company-mode)
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony))  
  ;; (delete 'company-semantic company-backends)
  ;; (define-key c-mode-map  [(tab)] 'company-complete)
  ;; (define-key c++-mode-map  [(tab)] 'company-complete)
  ;; (define-key c-mode-map  [C-tab] 'company-complete)
  ;; (define-key c++-mode-map  [C-tab] 'company-complete)
  ;;( add-to-list 'load-path (expand-file-name "~/.emacs.d/irony-mode/elisp/"))
  )

(defun custom-autocomplete ()
                                        ; start auto-complete with emacs
  (require 'auto-complete)
                                        ; do default config for auto-complete
  (require 'auto-complete-config)
  (ac-config-default)

                                        ; let's define a function which initializes auto-complete-c-headers and gets called for c/c++ hooks
  (defun my:ac-c-header-init ()
    (require 'auto-complete-c-headers)
    (add-to-list 'ac-sources 'ac-source-c-headers)
    ;; (add-to-list 'achead:include-directories '"/Applications/Xcode.app/Contents/Developer/usr/llvm-gcc-4.2/lib/gcc/i686-apple-darwin11/4.2.1/include")
    )
                                        ; now let's call this function from c/c++ hooks
  (add-hook 'c++-mode-hook 'my:ac-c-header-init)
  (add-hook 'c-mode-hook 'my:ac-c-header-init)
  (defun my-c++-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

                                        ; turn on Semantic
  (semantic-mode 1)
                                        ; let's define a function which adds semantic as a suggestion backend to auto complete
                                        ; and hook this function to c-mode-common-hook
  (defun my:add-semantic-to-autocomplete() 
    (add-to-list 'ac-sources 'ac-source-semantic)
    )
  (add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
                                        ; turn on ede mode 
  (global-ede-mode 1)
                                        ; create a project for our program.
  ;; (ede-cpp-root-project "exxxxx" :file "v:/workspace_avs/exxxx/Sources/tp.cpp"
  ;; 	        :include-path '("v:/mlx/log4cpp")
  ;;                       :include-path '("v:/mlx/include")
  ;;                       :include-path '("v:/mlx/")
  ;;                       :include-path '("v:/workspace_avs/exxxx/Configurations/FT/"))
                                        ; you can use system-include-path for setting up the system header file locations.
                                        ; turn on automatic reparsing of open buffers in semantic
                                        ; create a project for our program.

                                        ; you can use system-include-path for setting up the system header file locations.
                                        ; turn on automatic reparsing of open buffers in semantic
  (global-semantic-idle-scheduler-mode 1)
  )

(defun custom-irony ()
                                        ; define a function to start irony mode for c/c++ modes
  (defun my:irony-enable()
    (interactive)
    (when (member major-mode 'irony-known-modes)
      (irony-mode 1)))

                                        ; also enable ac plugin
  ;; (irony-enable 'ac)
  (require 'ac-irony)

  (add-hook 'c++-mode-hook 'my:irony-enable)
  (add-hook 'c-mode-hook 'my:irony-enable)

  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  ;; (define-key irony-mode-map [C-tab] 'irony-completion-at-point-async)
  ;; (define-key irony-mode [C-tab] 'irony-completion-at-point-async)

  ;; (defun my-irony-mode-hook ()
  ;;   (define-key irony-mode-map [remap completion-at-point]
  ;;     'irony-completion-at-point-async)
  ;;   (define-key irony-mode-map [remap complete-symbol]
  ;;     'irony-completion-at-point))

  ;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  ;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

                                        ; start google-c-style with emacs
  (require 'google-c-style)
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent)
  
  )

(defun custom-flycheck ()
  (add-hook 'after-init-hook #'global-flycheck-mode)
  )

(defun custom-keys ()
  ;; Easy transition between buffers: M-arrow-keys
  (if (equal nil (equal major-mode 'org-mode))
      (windmove-default-keybindings 'meta))

  ;; Commands:
  ;; Undo
  (global-set-key (kbd "M-z") 'undo)
  ;; Keyboard quit
  (global-set-key (kbd "M-q") 'keyboard-quit)

  ;; Add comment according major mode
  (global-set-key (kbd "M-/") 'comment-dwim)
  ;; Set mark command
  (global-set-key (kbd "M-m") 'set-mark-command)
  ;; Back to indentation
  (global-set-key (kbd "M-\\") 'back-to-indentation)

  ;; Add comment according major mode
  (global-set-key (kbd "M-/") 'comment-dwim)
  ;; Set mark command
  (global-set-key (kbd "M-m") 'set-mark-command)
  ;; Back to indentation
  (global-set-key (kbd "M-\\") 'back-to-indentation)

  (global-set-key (kbd "<f2>") 'bs-show)
  (global-set-key (kbd "<f7>") 'kmacro-start-macro)
  (global-set-key (kbd "<f8>") 'kmacro-end-macro)
  (global-set-key (kbd "<f9>") 'kmacro-call-macro)
  (global-set-key (kbd "<f11>") 'ido-dired)
  (global-set-key (kbd "<f12>") 'sr-speedbar-toggle)
  )

(defun custom-yasnippet ()
  (require 'yasnippet)
  (yas-global-mode 1)
  )

(defun custom-imenu ()
  ;; Imenu
  (require 'imenu)

  (setq imenu-auto-rescan      t) ;; автоматически обновлять список функций в буфере
  (setq imenu-use-popup-menu nil) ;; диалоги Imenu только в минибуфере
  (global-set-key (kbd "<f6>") 'imenu) ;; вызов Imenu на F6
  )

(defun custom-other ()
  ;; Dired
  (require 'dired)
  (setq dired-recursive-deletes 'top)
  (require 'iedit)
  (global-set-key (kbd "C-c ;") 'iedit-mode)
  )

(defun custom-org ()
  (require 'org)
  (global-set-key "\C-ca" 'org-agenda) ;; поределение клавиатурных комбинаций для внутренних
  (global-set-key "\C-cb" 'org-iswitchb) ;; подрежимов org-mode
  (global-set-key "\C-cl" 'org-store-link)
  (add-to-list 'auto-mode-alist '("\\.org$" . Org-mode)) ;; ассоциируем *.org файлы с org-mode
  )

(defun custom-flymake-google ()
  (defun my:flymake-google-init () 
    (require 'flymake-google-cpplint)
    (custom-set-variables
     '(flymake-google-cpplint-command "cpplint"))
    (flymake-google-cpplint-load)
    )
  (add-hook 'c-mode-hook 'my:flymake-google-init)
  (add-hook 'c++-mode-hook 'my:flymake-google-init)

                                        ; start google-c-style with emacs
  (require 'google-c-style)
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent)
)


(custom-package)
(custom-global)
(custom-bookmark)
(require 'cc-mode)
;; (require 'company)
(custom-ggtags)

;; (require 'custom-company)
;; (require 'custom-company-c-headers)
;; (require 'custom-autocomplete)

(custom-autocomplete)
;; (require 'custom-autocomplete-c-headers)
;; (require 'custom-irony)
(custom-irony)
;; (require 'custom-semantic)
;; (require 'custom-flymake-google)
(custom-flycheck)
(custom-flymake-google)
(custom-keys)
(custom-yasnippet)
(custom-imenu)
(custom-other)
(custom-org)
(elscreen-start)
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(require 'color-theme-mac-classic)
(color-theme-mac-classic)
(nyan-mode)
(ecb-activate)
;; (require 'eide)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(display-time-mode t)
 '(ecb-options-version "2.40")
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Terminus" :foundry "xos4" :slant normal :weight normal :height 105 :width normal))))
 '(completions-common-part ((t (:inherit default :foreground "red"))))
 '(show-paren-match ((((class color) (background light)) (:background "azure2")))))
