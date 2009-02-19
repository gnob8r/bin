;; ; Compatibility Layer:

(setq running-xemacs (featurep 'xemacs))
(setq running-emacs  (not running-xemacs))
(setq running-osx    (or (featurep 'mac-carbon) (eq 'ns window-system)))

;; Pathing:
;; leaving in the ~ryan part, makes it easier to test from guest acct
(add-to-list 'load-path (expand-file-name "~ryan/Bin/elisp") t)
(add-to-list 'load-path (expand-file-name "~ryan/Bin/elisp/third-party") t)
(add-to-list 'load-path (expand-file-name "~ryan/Sites/emacs/elisp") t)

(if (and running-osx (not (member "/Users/ryan/Bin" exec-path)))
    ;; deal with OSX's wonky enivronment by forcing PATH to be correct.
    ;; argh this is stupid
    (let* ((path   (shell-command-to-string "/bin/bash -lc 'echo -n $PATH'"))
           (cdpath (shell-command-to-string "/bin/bash -lc 'echo -n $CDPATH'"))
           (path-list (split-string path ":" t)))
      (setenv "PATH" path)
      (setenv "CDPATH" cdpath)
      (dolist (p path-list) (add-to-list 'exec-path p t))))

;; --- ;;;###autoload
(require 'autoload)

(eval-when-compile (require 'cl))
;; (require 'cl)

(defun rwd-recompile-init ()
  (interactive)
  (byte-recompile-directory (expand-file-name "~/Bin/elisp") 0))

;; from technomancy with some tweaks
(defun rwd-autoloads ()
  "Regenerate the autoload definitions file if necessary and load it."
  (interactive)
  (let* ((el-file (or (buffer-file-name) load-file-name))
         (el-root-dir (file-name-directory
                       (or (file-symlink-p el-file) el-file)))
         (autoload-file (concat el-root-dir generated-autoload-file)))
    (if (or (not (file-exists-p autoload-file))
            (some (lambda (f) (file-newer-than-file-p f autoload-file))
                  (directory-files el-root-dir t "\\.el$")))
        (let ((generated-autoload-file autoload-file))
          (message "Updating autoloads...")
          (update-directory-autoloads el-root-dir)
          (load autoload-file) ; helps rwd-recompile-init dependencies
          (rwd-recompile-init)
          ))
    (load autoload-file)))

(rwd-autoloads)

;; My libs: TODO: remove these in favor of autoloading
(load "rwd-modes")
(load "rwd-keywords")                   ; depends on modes, for now

;; enable/disable commands:
(put 'erase-buffer 'disabled nil) ; nukes stupid warning

(if window-system
    (add-hook 'after-init-hook
              (lambda ()
                (rwd-resize-small)
                (run-with-idle-timer 0.25 nil #'rwd-resize-small))
              t))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(apropos-do-all t)
 '(backup-by-copying-when-linked t)
 '(blank-chars (quote (tabs trailing lines space-before-tab)))
 '(blank-line-length 82)
 '(blank-style (quote (color)))
 '(column-number-mode t)
 '(comint-input-ignoredups t)
 '(comment-empty-lines (quote (quote eol)))
 '(compilation-error-regexp-alist (quote (bash java gnu gcc-include)))
 '(dired-recursive-deletes (quote top))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(eval-expression-print-length nil)
 '(eval-expression-print-level nil)
 '(ffap-file-finder (quote find-file-other-window))
 '(find-file-visit-truename t)
 '(global-auto-revert-mode t)
 '(hippie-expand-try-functions-list (quote (try-expand-all-abbrevs try-expand-list try-expand-dabbrev-visible try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol try-expand-tag try-complete-file-name-partially try-complete-file-name)))
 '(history-length 1000)
 '(imenu-max-items 50)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(oddmuse-directory "~/Library/Caches/oddmuse")
 '(oddmuse-username "RyanDavis")
 '(override-keymap-rules (quote (("\230" bury-buffer (ruby python emacs-lisp)) ("\214" rwd-scroll-top (shell comint)))))
 '(safe-local-variable-values (quote ((racc-token-length-max . 14))))
 '(save-place t nil (saveplace))
 '(save-place-limit 250)
 '(save-place-save-skipped nil)
 '(save-place-skip-check-regexp "\\`/\\(cdrom\\|floppy\\|mnt\\|\\([^@/:]*@\\)?[^@/:]*[^@/:.]:\\)")
 '(savehist-mode t nil (savehist))
 '(scroll-bar-mode nil)
 '(search-whitespace-regexp nil)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(tab-width 2)
 '(tool-bar-mode nil nil (tool-bar))
 '(tooltip-mode nil)
 '(tramp-default-method "ssh")
 '(transient-mark-mode t)
 '(truncate-partial-width-windows nil)
 '(use-dialog-box nil)
 '(vc-handled-backends (quote (CVS SVN GIT)))
 '(vc-p4-require-p4config t)
 '(vc-path (quote ("/opt/local/bin" "/usr/local/bin")))
 '(vc-svn-program-name "/opt/local/bin/svn")
 '(visible-bell t)
 '(warning-suppress-types (quote ((undo discard-info))))
 '(wdired-allow-to-change-permissions (quote advanced)))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blank-line ((t (:background "gray80"))))
 '(blank-line-face ((t (:background "gray90"))))
 '(diff-added ((t (:inherit diff-changed :foreground "green4"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red4"))))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background light)) (:foreground "Dark Blue"))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background light)) (:foreground "SlateBlue4"))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "Forest Green")))))

(require 'loadhist)
(load "cl-extra")
(defun whatsnew ()
  (cl-prettyprint
   (sort
    (remove-duplicates
     (mapcar (lambda (n) (feature-file n))
             (set-difference 
              features
              '(help-fns help-mode view tooltip ediff-hook vc-hooks
                         lisp-float-type tool-bar mwheel dnd fontset
                         image fringe abbrev lisp-mode register page
                         menu-bar rfn-eshadow timer select scroll-bar
                         mldrag mouse jit-lock font-lock syntax
                         facemenu font-core frame ucs-tables georgian
                         utf-8-lang misc-lang vietnamese tibetan thai
                         lao korean japanese hebrew greek romanian
                         slovak czech european ethiopic kannada tamil
                         malayalam devanagari indian cyrillic chinese
                         case-table jka-cmpr-hook help simple button
                         faces cus-face text-properties overlay md5
                         base64 format mule env custom widget
                         backquote make-network-process mac-carbon
                         emacs)))) 'string-lessp)))

; (whatsnew)
