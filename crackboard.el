;; Constants: the endpoint for heartbeat, the heartbeat interval, the session key
(defvar crackboard-session-key '())
(setq crackboard-heartbeat-endpoint "https://crackboard.dev/heartbeat")
(setq crackboard-heartbeat-interval (* 2 60 1000)) ;; 2m millis

;; Functions: one to start the daemon, one to send heartbeats
(defun crackboard-send-heartbeat (l)
  "Send heartbeat to crackboard.dev in language l"
  (let ((url-request-method "POST")
	(url-request-extra-headers
	 '(("Content-Type" . "application/json")))
	(url-request-data (json-encode '(("timestamp" . (format-time-string "%Y-%m-%dT%TZ" (current-time) t)) ;; Timestamp, Zulu
		    ("session_key" . crackboard-session-key)
		    ("language_name" . (crackboard-filetype)))))))
    (url-retrieve crackboard-heartbeat-endpoint))

(defun crackboard (k)
  "Start crackboard session with key k"
  (interactive "sKey: ")
  (setq crackboard-session-key k)
  ;; do something else
  )

(defun crackboard-filetype ()
  "Locate filetype of current buffer (hacky rn)"
  (replace-regexp-in-string "-mode$" "" (symbol-name major-mode)))


;; Functionality: track typing, track saving
(json-encode '(("timestamp" . (format-time-string "%Y-%m-%dT%TZ" (current-time) t)) ;; Timestamp, Zulu
	       ("session_key" . crackboard-session-key)
	       ("language_name" . "foo")))
