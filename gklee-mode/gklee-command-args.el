;; Adapted by Ian Briggs from gklee-mode.el
;; ianbriggs@utah.edu


;;****************************************************************************;;
;;**                            Option alists                               **;;
;;****************************************************************************;;
(setq gklee-toggle-options-alist
      '(("-PR-use-dep" . nil)
	("-asm-verbose" . nil)
	("-avoid-oob-check" . nil)
	("-bc-cov" . nil)
	("-check-barrier-redundant" . nil)
	("-check-BC" . t)
	("-check-MC" . t)
	("-check-WD" . t)
	("-check-div-zero" . nil)
	("-check-volatile" . t)
	("-emit-all-errors" . nil)
	("-ignore-concur-bug" . nil)
	("-race-prune" . nil)
	("-reduce-tests" . nil)
	("-simd-schedule" . nil)
	("-suppress-external-warnings" . nil)
	("-symbolic-config" . nil)
	("-trace" . nil)
	("-verbose" . nil)))

(setq gklee-int-options-alist
      '(("-check-level=" . 1)
	("-device-capability=" . 2)
	("-max-memory=" . 0)
	("-max-time=" . 0)))

(setq gklee-string-options-alist
      '(("-output-dir=" . ".")
	("-run-in=" . ".")))


;;****************************************************************************;;
;;**                           Command line args                            **;;
;;****************************************************************************;;
(defcustom gklee-gklee-user-args ""
  "Command line arguments to pass to Gklee"
  :type '(string))

(defcustom gklee-compile-user-args ""
  "Command line arguments to pass to llvm"
  :type '(string))

(defcustom gklee-program-user-args ""
  "Command line arguments to pass to your program"
  :type '(string))


;;****************************************************************************;;
;;**                   Interactive functions for options                    **;;
;;****************************************************************************;;
(defun gklee-set-command-option (option target_alist new_value)
  (let ((old_value (assoc option target_alist)))
    (if (not old_value)
	(message "option to set does not exist")
      (setcdr old_value new_value)
      (message (format "set %s to %s" (car old_value) (cdr old_value))))))


;; Binary options
(defun gklee-toggle-option (option)
  (gklee-set-command-option
   option
   gklee-toggle-options-alist
   (not (cdr (assoc option gklee-toggle-options-alist)))))


(defun gklee-toggle-dependency-analysis ()
  (interactive) (gklee-toggle-option "-PR-use-dep"))
(defun gklee-toggle-asm-verbose ()
  (interactive) (gklee-toggle-option "-asm-verbose"))
(defun gklee-toggle-oob-check ()
  (interactive) (gklee-toggle-option "-avoid-oob-check"))
(defun gklee-toggle-bytecode-coverage ()
  (interactive) (gklee-toggle-option "-bc-cov"))
(defun gklee-toggle-check-barrier-redundant ()
  (interactive) (gklee-toggle-option "-check-barrier-redundant"))
(defun gklee-toggle-bank-conflicts ()
  (interactive) (gklee-toggle-option "-check-BC"))
(defun gklee-toggle-memory-coalesce ()
  (interactive) (gklee-toggle-option "-check-MC"))
(defun gklee-toggle-warp-divergence ()
  (interactive) (gklee-toggle-option "-check-WD"))
(defun gklee-toggle-div-zero-check ()
  (interactive) (gklee-toggle-option "-check-div-zero"))
(defun gklee-toggle-check-volatile ()
  (interactive) (gklee-toggle-option "-check-volatile"))
(defun gklee-toggle-all-errors ()
  (interactive) (gklee-toggle-option "-emit-all-errors"))
(defun gklee-toggle-concurrency-bug ()
  (interactive) (gklee-toggle-option "-ignore-concur-bug"))
(defun gklee-toggle-race-prune ()
  (interactive) (gklee-toggle-option "-race-prune"))
(defun gklee-toggle-reduce-tests ()
  (interactive) (gklee-toggle-option "-reduce-tests"))
(defun gklee-toggle-simd-schedule ()
  (interactive) (gklee-toggle-option "-simd-schedule"))
(defun gklee-toggle-external-warnings ()
  (interactive) (gklee-toggle-option "-suppress-external-warnings"))
(defun gklee-toggle-symbolic-config ()
  (interactive) (gklee-toggle-option "-symbolic-config"))
(defun gklee-toggle-trace ()
  (interactive) (gklee-toggle-option "-trace"))
(defun gklee-toggle-verbose ()
  (interactive) (gklee-toggle-option "-verbose"))


;; Integer options
(defun gklee-set-int-option (option value min max)
  (if (or (> value max) (< value min))
      (message
       (format "value given is outside of range %d to %d, no changes made"
	       min max))
    (gklee-set-command-option option gklee-int-options-alist value)))

(defun gklee-set-check-level (n)
  (interactive "nCheck Level (0)=none (1)=shared mem (2)=full : ")
  (gklee-set-int-option "-check-level=" n 0 2))
(defun gklee-set-device-capability (n)
  (interactive "nDevice Capability (0)=1.0 and 1.1 (1)=1.2 and 1.3 (2)=2.x : ")
  (gklee-set-int-option "-device-capability=" n 0 2))
(defun gklee-set-max-memory (n)
  (interactive "nMaximum memory allowed: ")
  (gklee-set-int-option "-max-memory=" n 0 most-positive-fixnum))
(defun gklee-set-max-time (n)
  (interactive "nMaximum time allowed: ")
  (gklee-set-int-option "-max-time=" n 0 most-positive-fixnum))


;; String options
(defun gklee-set-string-option (option value)
  (gklee-set-command-option option gklee-string-option-alist value))

(defun gklee-set-output-dir (dir)
  (interactive "DOutput directory: ")
  (gklee-set-string-option "-output-dir=" dir))
(defun gklee-set-run-sir (dir)
  (interactive "DDirectory to run in: ")
  (gklee-set-string-option "-run-in=" dir))

;; Command line args
(defun gklee-modify-gklee-args ()
  (interactive)
  (setq gklee-gklee-user-args (read-string
			       "Enter command line arguments for Gklee:"
			       gklee-gklee-user-args)))
(defun gklee-modify-compile-args ()
  (interactive)
  (setq gklee-compile-user-args (read-string
				 "Enter command line arguments for llvm: "
				 gklee-compile-user-args)))
(defun gklee-modify-program-args ()
  (interactive)
  (setq gklee-program-user-args (read-string
				 "Enter command line arguments for your program: "
				 gklee-program-user-args)))


;;****************************************************************************;;
;;**                       Global key bindings                              **;;
;;****************************************************************************;;
;; Boolean options
(global-set-key "\M-gtgc" 'gklee-toggle-bytecode-coverage)
(global-set-key "\M-gtbc" 'gklee-toggle-bank-conflicts)
(global-set-key "\M-gtmc" 'gklee-toggle-memory-coalesce)
(global-set-key "\M-gtwd" 'gklee-toggle-warp-divergence)
(global-set-key "\M-gtrb" 'gklee-toggle-check-barrier-redundant)
(global-set-key "\M-gtcv" 'gklee-toggle-check-volatile)
(global-set-key "\M-gtcb" 'gklee-toggle-concurrency-bug)
(global-set-key "\M-gspr" 'gklee-toggle-race-prune)
(global-set-key "\M-gtrt" 'gklee-toggle-reduce-tests)
(global-set-key "\M-gtv"  'gklee-toggle-verbose)

;; Integer options
(global-set-key "\M-gscl" 'gklee-set-check-level)
(global-set-key "\M-gsdc" 'gklee-set-device-capability)

;; Command line options
(global-set-key "\M-gupa" 'gklee-modify-program-args)
(global-set-key "\M-guca" 'gklee-modify-compile-args)
(global-set-key "\M-gaga" 'gklee-modify-gklee-args)

;;TODO bind these
(global-set-key "\M-gor"  'gklee-open-remote-package)
(global-set-key "\M-gr"   'gklee-run)
(global-set-key "\M-gk"   'gklee-kill)
