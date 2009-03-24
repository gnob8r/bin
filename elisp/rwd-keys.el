;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Keys & Menus:
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(progn
  (global-set-key (kbd "<f7>")    'rwd-toggle-split)
  (global-set-key (kbd "<f8>")    'rwd-swap-buffers)
  (global-set-key (kbd "C-M-x")   'bury-buffer)
  ;; (global-set-key (kbd "C-c #")   'kmacro-insert-counter)
  ;; (global-set-key (kbd "C-c 1")   'my-reset-macro-counter)
  ;; (global-set-key (kbd "C-c C-r") 'recompile)
  (global-set-key (kbd "C-c e")   'erase-buffer)
  ;; (global-set-key (kbd "C-c f")   'my-selective-display)
  (global-set-key (kbd "C-c o")   'rwd-occur-buffer)
  (global-set-key (kbd "C-x /")   'align-regexp)
  (global-set-key (kbd "C-x C-b") 'bs-show)
  (global-set-key (kbd "C-x C-p") 'find-file-at-point)
  (global-set-key (kbd "C-x C-t") 'toggle-buffer)
  ;; (global-set-key (kbd "C-M-.")     'etags-select-find-tag)
  ;; (global-set-key (kbd "M-?")     'etags-select-find-tag-at-point)
  ;; (global-set-key (kbd "M-C-+")   'sacha/increase-font-size)
  ;; (global-set-key (kbd "M-C--")   'sacha/decrease-font-size)
  (global-set-key (kbd "M-C-y")   'kill-ring-search)
  (global-set-key (kbd "M-[")     'outdent-rigidly-4)
  (global-set-key (kbd "M-]")     'indent-rigidly-4)
  (global-set-key (kbd "M-s")     'fixup-whitespace)

  (define-key emacs-lisp-mode-map       (kbd "C-c e") 'my-eval-and-replace)
  (define-key lisp-interaction-mode-map (kbd "C-c e") 'my-eval-and-replace)

  ;; iconify bugs the crap out of me:
  (when window-system (global-unset-key "\C-z"))

  ;; compatibility:
  (if running-emacs
      (progn
        (global-set-key (kbd "M-g")      'goto-line)
        (global-set-key (kbd "<C-up>")   'rwd-previous-line-6)
        (global-set-key (kbd "<C-down>") 'rwd-forward-line-6)
        (global-set-key (kbd "<M-up>")   'rwd-scroll-up)
        (global-set-key (kbd "<M-down>") 'rwd-scroll-down)
        (global-set-key (kbd "C-M-l")    'rwd-scroll-top)))

  (if running-osx
      (define-key global-map [ns-drag-file] 'ns-find-file))

  ;; This allows me to enforce that bury-buffer is bound to C-M-x
  ;; regardless of mode (YAY!)
  (require 'override-keymaps)
  (override-keymaps))

;; FIX: blech!
;; (mapcar (lambda (mode)
;;           (define-key mode (kbd "C-c C-a") 'autotest-switch))
;;         '(diff-mode-map
;;           diff-minor-mode-map
;;           grep-mode-map
;;           help-mode-map))

;; this is so awesome - occur easily inside isearch
;;;###autoload
(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
               (regexp-quote isearch-string))))))

;; grep all same extension files from inside isearch
;;;###autoload
(define-key isearch-mode-map (kbd "C-S-o")
  (lambda ()
    (interactive)
    (grep-compute-defaults)
    (lgrep (if isearch-regexp isearch-string (regexp-quote isearch-string))
           (format "*.%s" (file-name-extension (buffer-file-name)))
           default-directory)
    (isearch-abort)))

;; ;;;###autoload
;; (eval-after-load 'shell-mode
;;   (def-hook shell-mode
;;     (define-key shell-mode-map (kbd "C-z") 'comint-stop-subjob)
;;     (define-key shell-mode-map (kbd "M-<return>") 'shell-resync-dirs)))

;;;###autoload
(hook-after-load-new shell shell-mode
  (define-key shell-mode-map (kbd "C-z") 'comint-stop-subjob)
  (define-key shell-mode-map (kbd "M-<return>") 'shell-resync-dirs))

;;;###autoload
(hook-after-load-new dired dired-mode
  (define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)
  (if running-emacs
      (define-key dired-mode-map "k" 'dired-kill-subdir)))

;;;###autoload
(eval-after-load 'p4
  '(define-key p4-prefix-map (kbd "A") 'p4-diff-all-opened))
