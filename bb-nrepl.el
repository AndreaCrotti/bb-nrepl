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

;;;###autoload
(defun bb-and-connect ()
  (interactive)
  (let* ((buffer (get-buffer-create bb-buffer-name)))
    (if (comint-check-proc buffer)
        (cider-connect '(:host "localhost" :port 1667))
      (make-comint-in-buffer bb-buffer-name buffer bb-program nil "--nrepl-server"))))
