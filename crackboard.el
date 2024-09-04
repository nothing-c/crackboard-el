;; Constants: the endpoint for heartbeat, the heartbeat interval, the session key
(defvar crackboard-session-key '())
(setq crackboard-heartbeat-endpoint "https://crackboard.dev/heartbeat")
(setq crackboard-heartbeat-interval (* 2 60 1000)) ;; 2m millis

;; Functions: one to start the daemon, one to send heartbeats

;; Functionality: track typing, track saving
