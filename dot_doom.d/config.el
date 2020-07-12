;;; .doom.d/config.el -*- lexical-binding: t; -*-

; Custom vars
(setq
 +org-path "~/Dropbox/org/"
 ;; +org-publish-path "~/Dropbox/notes.yosevu.com/public/"
 ;; +org-publish-public-path "~/Dropbox/notes.yosevu.com/public/"
 +org-roam-path "~/Dropbox/org/roam/"
 +org-journal-path "~/Dropbox/org/roam/private/journal/"
 +org-capture-tasks-path "~/Dropbox/org/tasks/"
 +org-capture-tasks-file "~/Dropbox/org/tasks/tasks.org"
 +org-capture-work-tasks-file "~/Dropbox/org/tasks/work.org"
 +org-capture-habits-file "~/Dropbox/org/tasks/habits.org"
 +org-capture-questions-file "~/Dropbox/org/tasks/questions.org"
 +org-capture-inbox-file "~/Dropbox/org/roam/private/inbox.org")
 ;; +projectile-personal-projects-path "~/Documents/projects/personal/"
 ;; +projectile-work-projects-path "~/Documents/projects/work/"

;; Font and themes
(load-theme 'doom-nord t)
;; (load-theme 'doom-nord-light t)
;; (load-theme 'doom-opera-light t)
;; (load-theme 'doom-palenight t)
;; (load-theme 'doom-solarized-light t)
;; (load-theme 'dracula t)
;; (load-theme 'palenight t)

(doom-themes-org-config) ; Correct and improve org-mode's native fonts
;; (mac-auto-operator-composition-mode t) ; Ligature support for fonts like Fira Code. Works with emacs-mac.

;; Emacs Dashboard
(use-package dashboard
  :ensure t
  :init ; add config
  (progn
    (setq dashboard-items '((agenda . 5)
                            (bookmarks .5)
                            (projects . 5)
                            (recents . 5)
                            (registers . 5)))
    (setq dashboard-startup-banner 'official)
    (setq dashboard-footer-messages '(
                                      "We like to say that we don't get to choose our parents, that they were given by chance--yet we can truly choose whose children we'd like to be. - Seneca"
                                      "Man lives on one quarter of what he eats. On the other three quarters live his doctors. - Unknown"
                                      "If you want everything to be familiar, you will never learn anything new because it can't be significantly different from what you already know - Rich Hickey"
                                      "The best thing a human being can do is to help another human being know more. - Charlie Munger"
                                      "In my whole life, I have known no wise people (over a broad subject matter area) who didn't read all the time — none, zero. - Charlie Munger"
                                      "To be everywhere is to be nowhere. - Seneca"
                                      "If you don't know where you're going, you might not get there - Yogi Berra"
                                      "Substitute nuance for novelty - Angela Duckworth"
                                      "If you want to test your memory, try to remember what you were worrying about one year ago today. - E. Joseph Cossman")))
  :config
  (dashboard-setup-startup-hook))

(use-package forge
  :after magit)

;;(load! "lisp/alfred-org-capture")

;; Org-mode
;; Set initial frame size and position
(add-to-list 'initial-frame-alist '(fullscreen . fullheight))
(add-to-list 'initial-frame-alist '(width . 0.5))
(add-to-list 'initial-frame-alist '(left . 0))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(require 'org)
(require 'ob-clojure)
(require 'cider)

(add-to-list 'org-modules 'org-habit t)

(setq
 org-ellipsis " ▼ "
 org-log-done 'time ; Insert a timestamp after the headline when a task is marked done.
 org-log-into-drawer t
 org-treat-insert-todo-heading-as-state-change t
 org-babel-clojure-backend 'cider
 projectile-project-search-path '("~/Documents/projects/personal/" "~/Documents/projects/work/")
 visual-line-mode t)

;; tide config
(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; org-journal config
(use-package org-journal
  :after org
  :init
  (map! :leader
        (:prefix ("j" . "journal") ;; org-journal bindings
         :desc "Create new journal entry" "j" #'org-journal-new-entry
         :desc "Open previous entry" "p" #'org-journal-open-previous-entry
         :desc "Open next entry" "n" #'org-journal-open-next-entry
         :desc "Search journal" "s" #'org-journal-search-forever))
  :custom
  (org-journal-dir +org-journal-path)
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-file-type 'weekly)
  (org-journal-file-header "#+title: Week %V, %Y \n#+roam_tags: journal \n\n [[file:journal.org][Journal]] \n\n")
  (org-journal-date-format "%Y-%m-%d (%A)")
  (org-journal-time-prefix "")
  (org-journal-time-format ""))

(setq
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-css-indent-offset 2
 js-indent-level 2
 json-reformat:indent-width 2
 prettier-js-args '("--single-quote")
 dired-dwim-target t ; http://ergoemacs.org/emacs/emacs_dired_tips.html
 org-ellipsis " ▾ "
 org-bullets-bullet-list '("·")
 org-tags-column -80
 org-log-done 'time
 css-indent-offset 2
 ;; org-refile-targets (quote ((nil :maxlevel . 1)))
 org-capture-templates '(("i" "inbox" entry
                          (file +org-capture-inbox-file)
                          "* %?" :prepend t :kill-buffer t :empty-lines-before 1)
                         ("t" "task" entry
                          (file +org-capture-tasks-file)
                          "* TODO %? %^g" :prepend t :kill-buffer t :empty-lines-before 1)
                         ("w" "work" entry
                          (file +org-capture-work-tasks-file)
                          "* TODO %? %^g" :prepend t :kill-buffer t :empty-lines-before 1)
                         ("q" "question" entry
                          (file +org-capture-questions-file)
                          "* TODO %? %^g" :prepend t :kill-buffer t :empty-lines-before 1)
                         ("h" "habit" entry
                          (file +org-capture-habits-file)
                          "* TODO %? %^g" :prepend t :kill-buffer t :empty-lines-before 1)))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
      ;; '((sequence "TODO(t)" "DONE(d)")))
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MISSED(m)")))

(use-package org-super-agenda
  :ensure t
  :config (org-super-agenda-mode))

(setq org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name "Habits"
          :tag "pesonal"
          :habit t)
         (:name "Today"  ; Optionally specify section name
          :time-grid t  ; Items that appear on the time grid
          :date today
          :order 1)
         (:name "Due Today"
          :deadline today
          :order 2)
         (:name "Next"
          :todo "NEXT"
          :order 3)
         (:name "Important"
          :priority "A"
          :order 4)
         (:name "Soon"
          :scheduled future
          :order 5)
         (:name "Overdue"
          :deadline past
          :order 6)))

(require 'htmlize)
(require 'org-roam)

(use-package! org-roam
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam"                        "r" #'org-roam
        :desc "org-roam-insert"                 "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer"       "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file"              "f" #'org-roam-find-file
        :desc "org-roam-show-graph"             "g" #'org-roam-show-graph
        :desc "org-roam-insert"                 "i" #'org-roam-insert
        :desc "org-roam-capture"                "c" #'org-roam-capture)
        ;; (:prefix ("R" . "roam")
        ;;  (:prefix  ("d" . "by date")
        ;;   :desc "org-roam-dailies-date"           "d" #'org-roam-dailies-date
        ;;   :desc "org-roam-dailies-today"          "t" #'org-roam-dailies-today
        ;;   :desc "org-roam-dailies-tomorrow"       "m" #'org-roam-dailies-tomorrow
        ;;   :desc "org-roam-dailies-yesterday"      "y" #'org-roam-dailies-yesterday))
  :custom
  (org-roam-directory +org-roam-path)
  (org-roam-index-file "index.org")
  (org-roam-completion-system 'ivy)
  (org-roam-capture-templates
   '(("d" "personal (default)" plain (function org-roam--capture-get-point)
      "%?"
      :file-name "private/${slug}"
      :head "#+title: ${title}\n#+created: %<%Y-%m-%d>\n#+roam_alias:\n#+roam_tags: \"private\" \"personal\"\n\n"
      :unnarrowed t)
     ("w" "work" plain (function org-roam--capture-get-point)
      "%?"
      :file-name "private/${slug}"
      :head "#+title: ${title}\n#+created: %<%Y-%m-%d>\n#+roam_alias:\n#+roam_tags: \"private\" \"work\"\n\n"
      :unnarrowed t)
     ("f" "flash cards" plain (function org-roam--capture-get-point)
      "%?"
      :file-name "${slug}"
      :head "#+title: ${title}\n#+created: %<%Y-%m-%d>\n#+roam_alias:\n#+roam_tags: \" bkflash cards\"\n\n"
      :unnarrowed t)
     ("t" "draft" plain (function org-roam--capture-get-point)
      "%?"
      :file-name "${slug}"
      :head "#+title: ${title}\n#+created: %<%Y-%m-%d>\n#+roam_alias:\n#+roam_tags: \"drafts\"\n\n"
      :unnarrowed t)
     ("p" "public" plain (function org-roam--capture-get-point)
      "%?"
      :file-name "${slug}"
      :head "#+title: ${title}\n#+created: %<%Y-%m-%d>\n#+roam_alias:\n#+roam_tags: \"public\"\n\n"
      :unnarrowed t)))
  (org-roam-link-title-format "%s")
  :config
  (defun org-roam--title-to-slug (title)
    "Convert title to a filename-suitable slug. Uses hyphens rather than underscores."
    (cl-flet* ((nonspacing-mark-p (char)
                                  (eq 'Mn (get-char-code-property char 'general-category)))
               (strip-nonspacing-marks (s)
                                       (apply #'string (seq-remove #'nonspacing-mark-p
                                                                   (ucs-normalize-NFD-string s))))
               (cl-replace (title pair)
                           (replace-regexp-in-string (car pair) (cdr pair) title)))
      (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-")  ;; convert anything not alphanumeric
                      ("--*" . "-")  ;; remove sequential underscores
                      ("^-" . "")  ;; remove starting underscore
                      ("-$" . "")))  ;; remove ending underscore
             (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
        (s-downcase slug))))

;; org-roam org-export hook to add backlinks
    (defun my/org-roam--backlinks-list (file)
      (if (org-roam--org-roam-file-p file)
          (--reduce-from
           (concat acc (format "- [[file:%s][%s]]\n"
                               (file-relative-name (car it) +org-roam-path)
                               (org-roam--get-title-or-slug (car it))))
           "" (org-roam-db-query [:select [from] :from links :where (= to $s1)] file))
        ""))

  (defun my/org-export-preprocessor (backend)
    (let ((links (my/org-roam--backlinks-list (buffer-file-name))))
      (unless (string= links "")
        (save-excursion
          (goto-char (point-max))
          (insert (concat "\n* Backlinks\n") links))))))

  (add-hook 'org-export-before-processing-hook 'my/org-export-preprocessor)

;; org-publish config
(require 'ox-publish)
(setq org-publish-project-alist
      '(("org-notes"
      :auto-sitemap t
      :sitemap-filename "index.org"
      :sitemap-title "Index"
      :base-directory "~/Dropbox/org/roam/"
      :base-extension "org"
      :exclude "private"
      :publishing-directory "~/Dropbox/notes.yosevu.com/public/"
      :recursive t
      :publishing-function org-html-publish-to-html
      :section-numbers nil
      :html-head-extra "<link rel='stylesheet' href='css/main.css' type='text/css'/>"
      :headline-levels 4
      :auto-preamble t)
        ("org-static"
         :base-directory "~/Dropbox/notes.yosevu.com/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Dropbox/notes.yosevu.com/public/"
         :recursive t
         :publishing-function org-publish-attachment)
        ("org" :components ("org-notes" "org-static"))))

(after! org
  (defun yosevu/org-archive-done-tasks ()
    "Archive all done tasks."
    (interactive)
    (org-map-entries 'org-archive-subtree "/DONE" 'file))
  (require 'find-lisp)
  (setq
   org-agenda-files (directory-files +org-capture-tasks-path t "\\.org$" t))
   org-agenda-skip-scheduled-if-done t)

(use-package hydra)
(use-package org-fc
  :load-path "~/Dropbox/org-fc"
  :custom (org-fc-directories '("~/Dropbox/org/"))
           (org-fc-review-history-file "~/Dropbox/org-fc.tsv")
  :config
  (require 'org-fc-hydra)
  (require 'org-fc-keymap-hint))

(use-package org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory +org-roam-path))

(use-package pomidor
  :bind (("<f12>" . pomidor))
  :config (setq pomidor-sound-tick nil
                pomidor-sound-tack nil)
  :hook (pomidor-mode . (lambda ()
                          (display-line-numbers-mode -1) ; Emacs 26.1+
                          (setq left-fringe-width 0 right-fringe-width 0)
                          (setq left-margin-width 2 right-margin-width 0)
                          ;; force fringe update
                          (set-window-buffer nil (current-buffer))
                          (setq pomidor-play-sound-file
                                (lambda (file)
                                  (start-process "my-pomidor-play-sound"
                                                 nil
                                                 "mplayer"
                                                 file))))))

