;;; nils-functions --- funny functions -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Tramp hosts
(defvar n/tramp-hosts
      '(("sterz_n@juniper" . "/ssh:sterz_n@10.42.42.10:")))

(defun n/choose-tramp()
  "Choose tramp host to connect to."
  (interactive)
  (let ((host (completing-read "Choose a host: " n/tramp-hosts)))
	(find-file (concat (cdr (assoc host n/tramp-hosts)) "/"))))

(defun n/transparency-enable ()
  "Enables Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(80 . 80))
  (add-to-list 'default-frame-alist '(alpha . (80 . 80))))

(defun n/transparency-disable ()
  "Disable Editor transparency."
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(100 . 100))
  (add-to-list 'default-frame-alist '(alpha . (100 . 100))))

(defun n/search-ddg ()
  "Search DuckDuckGo for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?q=" q))))

(defun n/search-google ()
  "Search Google for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://google.com/search?q=" q))))

(defun n/search-wiki ()
  "Search wikipedia for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://wikipedia.org/wiki/" q))))

(defun n/search-cpp ()
  "Search wikipedia for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?sites=cppreference.com&q=" q))))

(defun n/search-stackoverflow ()
  "Search StackOverflow for a query."
  (interactive)
  (let ((q (read-string "Query: ")))
    (eww (concat "https://ddg.gg/?sites=stackoverflow.com&q=" q))))

(provide 'nils-functions)
;;; nils-functions.el ends here.
