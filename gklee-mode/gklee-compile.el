(load "gklee-command-args.el")
(defconst gklee-compile-buffer-name "*gklee-compile*")
(defconst gklee-compiler "gklee-nvcc") ;; must be in user's PATH

(defvar gklee-process nil) ;; the currently running gklee async process

(defun gklee-compile ()
  (interactive)
  (let ((file-name (buffer-file-name)) ;; get the filename to compile
	(process-connection-type nil) ;; use a pipe to connect to gklee-nvcc
	(buffer (get-buffer-create gklee-compile-buffer-name))) ;; output buffer
    (if file-name
	(with-current-buffer buffer
	  (erase-buffer)
	  (buffer-disable-undo)
	  (insert "executing with:\n")
	  (insert (concat "\tgklee-nvcc " gklee-compile-user-args file-name))
	  (insert "\n\nin directory:\n")
	  (insert (concat "\t" (shell-command-to-string "pwd")))
	  (insert "\n\ncommand output:\n")
	  ;; bind the process so we can use it if it needs killing
	  (let ((proc (apply 'start-process 
			     gklee-compile-buffer-name
			     gklee-compile-buffer-name
			     gklee-compiler
			     gklee-compile-user-args
			     file-name)))
	    (setq gklee-process proc)
	    proc) ;; run the bound process
	  (message "File does not exist"))))

  (defun gklee-kill ()
    (interactive)
    (if (and (y-or-n-p "Kill Gklee? ") gklee-process)
	(delete-process gklee-compile-process)
      nil) ;; do nothing if no process to kill or user didn't want to kill
    (message "Gklee is stopped"))


