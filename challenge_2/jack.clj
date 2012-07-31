; jack.clj
;
; Usage: clj jack.clj <source file path> <destination file path>
;
; Notes: This thing isn't the quickest or the most efficient.  I create a new file
;	instead of doing it in place. This is mainly because i couldn't figure out how
;	to do it in place with Clojure.
;
; Runtime (in seconds):
;	small_test.txt 		: ~0.15
;	war_and_peace.text 	: ~114.6

(import '(java.io File))
(import '(java.io FileReader))
(import '(java.io BufferedReader))
(require '[clojure.java.io :as io])
(use '[clojure.string :only (split)])

; Extract command line args
(def file_path (first *command-line-args*))
(def new_file_path (nth *command-line-args* 1))

; Simple variable to see if we're done.
(def is_complete false)

; Set the start time.
(def start_time (System/currentTimeMillis))

; Duh.
(defn does_file_exist [file_path]
	(let [f (File. file_path)]
		(cond
			(.exists f) true
			:else false)))

; Reverse a given word, and appends it to the file.
(defn reverse_and_write [word]
	(spit new_file_path (str (apply str (reverse word)) " ") :append true))

; Opens the file, reads it line-by-line, splits the line, and reverses each word.
(defn process_file [file_path]
	(with-open [reader (BufferedReader. (FileReader. file_path))]
		(let [seq (line-seq reader)]
			(doseq [item seq]
				(doseq [w (split item #"\s")]
					(reverse_and_write w))
				(spit new_file_path "\n" :append true))))
	(def is_complete true)) ; Should't be mutable, but it is because I'm lazy and don't know the language.

; Register the shutdown hook
(.addShutdownHook
	(Runtime/getRuntime)
	(Thread. (fn []
		(if is_complete
			() ; Do nothing if complete.
			(let [end_time (System/currentTimeMillis)]
				(println (float (/ (- end_time start_time) 1000)))
				(io/delete-file new_file_path)))))) ; This needs to happen before let, but its not working that way.

; Get started
(if (does_file_exist file_path)
	(process_file file_path)
	(println "\nError: Invalid file path."))
(let [end_time (System/currentTimeMillis)]
	(println (float (/ (- end_time start_time) 1000))))
