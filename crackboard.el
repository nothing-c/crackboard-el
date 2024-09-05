(defvar crackboard-session-key '())
(setq crackboard-heartbeat-endpoint "https://crackboard.dev/heartbeat")
(setq crackboard-heartbeat-interval (* 2 60)) ;; 2m seconds for float-time
(defvar crackboard-last-heartbeat '())

(defun crackboard-send-heartbeat (l)
  "Send heartbeat to crackboard.dev in language l"
  (let ((url-request-method "POST")
	(url-request-extra-headers
	 '(("Content-Type" . "application/json")))
	(url-request-data (json-encode `(("timestamp" . ,(format-time-string "%Y-%m-%dT%T.%3NZ" (current-time) t)) ;; Timestamp, Zulu
					 ("session_key" . ,crackboard-session-key)
					 ("language_name" . ,(crackboard-filetype))))))
    (url-retrieve crackboard-heartbeat-endpoint (lambda (status)
						  (let ((errp (plist-get status :error)))
						    (if errp
							(message "Crackboard error: %s" errp)
						      (message "Crackboard heartbeat sent")))))))

(defun crackboard-filetype ()
  "Locate filetype of current buffer (hacky rn)"
  (replace-regexp-in-string "-mode$" "" (symbol-name major-mode)))

(defun crackboard-change (b e l)
  "Send heartbeat on buffer change. Beginning/end/len are passed to every function that uses this hook, so we take them because we have to."
  (if (>= (- (float-time) crackboard-last-heartbeat) crackboard-heartbeat-interval) ;; Floats bad, but whatever
      (progn
	(setq crackboard-last-heartbeat (float-time))
	(crackboard-send-heartbeat (crackboard-filetype)))
    '())) ;; Punt

(defun crackboard-save ()
  "Send heartbeat on file save."
  (if (>= (- (float-time) crackboard-last-heartbeat) crackboard-heartbeat-interval)
      (progn
	(setq crackboard-last-heartbeat (float-time))
	(crackboard-send-heartbeat (crackboard-filetype)))
    '())) ;; I save way too often for this not to be on a timer

(defun crackboard (k)
  "Start crackboard session with key k"
  (interactive "sKey: ")
  (setq crackboard-session-key k)
  (setq crackboard-last-heartbeat (float-time))
  (add-hook 'after-save-hook 'crackboard-save)
  (add-hook 'after-change-functions 'crackboard-change))
