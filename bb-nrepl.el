;;; bb.el --- Collection of yasnippet snippets

;; Copyright (C) 2021 Andrea Crotti

;; Author: Andrea Crotti <andrea.crotti.0@gmail.com>
;; Keywords: cider,clojure
;; Version: 1.0
;; Package-Requires: ((yasnippet "0.8.0"))
;; Keywords: convenience, snippets
;; Homepage: https://github.com/AndreaCrotti/yasnippet-snippets

;;; Commentary:

;; Sample helper to work with cider and babashka scripts

;;; Code:

(defvar bb-program "bb")

(defvar bb-buffer-name "*bb-nrepl*")

(defun session-exists-p ()
  (let* ((proj-dir (plist-get params :project-dir))
         (host (plist-get params :host))
         (port (plist-get params :port))
         (session (seq-find (lambda (ses)
                              (let ((ses-params (cider--gather-session-params ses)))
                                (and (equal proj-dir (plist-get ses-params :project-dir))
                                     (or (null port)
                                         (equal port (plist-get ses-params :port)))
                                     (or (null host)
                                         (equal host (plist-get ses-params :host))))))
                            (sesman-current-sessions 'CIDER '(project)))))
    (when session
      t
      nil)))

;;;###autoload
(defun bb-and-connect ()
  (interactive)
  (let* ((buffer (get-buffer-create bb-buffer-name)))
    (when (not (comint-check-proc buffer))
      (make-comint-in-buffer bb-buffer-name buffer bb-program nil "--nrepl-server")
      (sleep-for 2))
    (if (not (seq-empty-p (cider-connections)))
        (cider-connect-sibling-clj '() (nth 0 (cider-connections)))
      (cider-connect '(:host "localhost" :port 1667)))))

(defun bb-is-babashka ()
  (and (equal 'clojure-mode major-mode)
       (equal "bb" (file-name-extension (buffer-file-name (current-buffer))))))

;; to automate even further, automatically create
;; (add-hook 'clojure-mode-hook
;;           (lambda ()
;;             (when (bb-is-babashka)
;;               (message "Connecting or creating a new bb nrepl server")
;;               (bb-and-connect))))
