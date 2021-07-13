;; --------------------------------------------------------- 
;; Expert System - Early Detection Of Hypertension
;; ---------------------------------------------------------
;; -- Sistem Pakar Kelompok 5: 
;; ----  (1703015184) - Dandi Anastasa
;; ----  (1703015142) - Dhiki Adriansyah
;; ----  (1703015223) - Muhammad Solehuddin Al-Khawarizmi
;; ----  (1703015225) - Mulvi Rahayu
;; 
;; ---------------------------------------------------------
;; README:
;; --------------------------------------------------------- 
;; -- This is just a simple system to diagnose Hypertension.
;; -- To execute, merely load, reset and run.
;; -- CLIPS Version 6.4
;; ---------------------------------------------------------


;; ======================
;; @FUNCTION_DECLARATION 
;; ======================

(deffunction ask-question (?question $?allowed-values)
   (print ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (print ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)
   
   (deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))



;; ======================
;; @RULE_DECLARATION 
;; ======================


;; @FORM INPUT
; (defrule ageIdentification
; =>
;     (printout t crlf "Masuk kedalam rentang usia manakah Anda?"
;         crlf "1. 5 - 10 Tahun"
;         crlf "2. 11 - 19 Tahun"
;         crlf "3. 20 - 60 Tahun"
;         crlf "4. Diatas 60 Tahun"
;         crlf ">> Jawab: "
;     )
;     (bind ?x (read))
;     (if (= ?x 1) then (printout t ">> Mohon maaf Anda tidak disarankan untuk menggunakan aplikasi ini, karena rentang usia Anda belum dapat diidentifikasi mengidap hipertensi" crlf))
;     (if (= ?x 2) then (assert (ageIdentification option-b)))
;     (if (or (= ?x 3) (= ?x 4)) then (assert (ageIdentification option-c)))
;     (if (or (< ?x 1) (> ?x 4)) then (printout t ">> IndexOutOfBounds: You just can only put value from 1 to 4" crlf))
; )

; ;; only execute when user input number 2 - 4 in ageIdentification rules
; (defrule genderIdentification
;     (ageIdentification option-b | option-c)
; =>
;     (printout t crlf crlf "Masukkan jenis kelamin Anda"
;         crlf "1. Laki-laki"
;         crlf "2. Perempuan"
;         crlf ">> Jawab: "
;     )
;     (bind ?x (read))
;     (if (= ?x 1) then (assert (genderIdentification option-a)))
;     (if (= ?x 2) then (assert (genderIdentification option-b)))
;     (if (or (< ?x 1) (> ?x 2)) then (printout t ">> IndexOutOfBounds: You just can only put value from 1 to 2" crlf))
; )


;; @SYMPTOMS
(defrule kelelahanQuestion ""
   (not (kelelahanQuestion-starts yes))
   (not (result ?))
=>
   (assert (kelelahanQuestion-starts (yes-or-no-p "Apakah anda mengalami kelelahan (yes no)?")))
)


(defrule sakitKepala ""
   (not (sakitKepala-starts yes))
   (not (result ?))
=>
   (assert (sakitKepala-starts (yes-or-no-p "Apakah anda mengalami sakit kepala (yes no)?")))
)

(defrule detakJantung ""
   (not (detakJantung-starts yes))
   (not (result ?))
=>
   (assert (detakJantung-starts (yes-or-no-p "Apakah detak jantung anda tidak beraturan (yes no)?")))
)

(defrule kejang ""
   (not (kejang-starts yes))
   (not (result ?))
=>
   (assert (kejang-starts (yes-or-no-p "Apakah anda mengalami kejang (yes no)?")))
)

(defrule mimisan ""
   (not (mimisan-starts yes))
   (not (result ?))
=>
   (assert (mimisan-starts (yes-or-no-p "Apakah anda mengalami mimisan? (yes no)?")))
)

(defrule demam ""
   (not (demam-starts yes))
   (not (result ?))
=>
   (assert (demam-starts (yes-or-no-p "Apakah anda mengalami demam? (yes no)?")))
)

(defrule mual ""
   (not (mual-starts yes))
   (not (result ?))
=>
   (assert (mual-starts (yes-or-no-p "Apakah anda mengalami mual (yes no)?")))
)




;; @KESIMPULAN

(defrule fatigue-kesimpulan ""
	(kelelahanQuestion-starts yes)
	(sakitKepala-starts yes)
	(demam-starts no)
	(mimisan-starts no)
	(kejang-starts no)
	(mual-starts no)
	(detakJantung-starts no)
	(not (result?))
	
	=>
	(assert (result "Anda mengalami fatigue(kelelahan)"))
	(assert (suggestion "Atur pola istirahat dan pola tidur anda dengan baik ya!"))
)

(defrule tifus-kesimpulan ""
	(kelelahanQuestion-starts yes)
	(sakitKepala-starts yes)
	(demam-starts yes)
	(mimisan-starts no)
	(kejang-starts no)
	(mual-starts no)
	(detakJantung-starts yes)
	(not (result?))
	
	=>
	(assert (result "Anda mengalami tifus"))
	(assert (suggestion "Segera periksa ke dokter untuk pemeriksaan lebih lanjut"))
)

(defrule stress-kesimpulan ""
	(kelelahanQuestion-starts yes)
	(sakitKepala-starts yes)
	(demam-starts yes)
	(mimisan-starts no)
	(kejang-starts yes)
	(mual-starts no)
	(detakJantung-starts no)
	(not (result?))
	
	=>
	(assert (result "Anda mengalami Stress"))
	(assert (suggestion "Hindari banyak pikiran negatif, dan disarankan menemui Psikolog"))
)

(defrule Dehidrasi-kesimpulan ""
	(kelelahanQuestion-starts yes)
	(sakitKepala-starts yes)
	(demam-starts no)
	(mimisan-starts no)
	(kejang-starts no)
	(mual-starts no)
	(detakJantung-starts yes)
	(not (result?))
	
	=>
	(assert (result "Anda mengalami Dehidrasi"))
	(assert (suggestion "Banyak minum air mineral"))
)

(defrule hipertensi-kesimpulan ""
	(kelelahanQuestion-starts yes)
	(sakitKepala-starts yes)
	(demam-starts yes)
	(mimisan-starts yes)
	(kejang-starts yes)
	(mual-starts yes)
	(detakJantung-starts yes)
	(not (result?))
	
	=>
	(assert (result "Anda mengalami Hipertensi!"))
	(assert (suggestion "Mohon untuk segera mengecek kondisi kesehatan Anda ke dokter."))
)

(defrule noSemua-kesimpulan ""
	(kelelahanQuestion-starts no)
	(sakitKepala-starts no)
	(demam-starts no)
	(mimisan-starts no)
	(kejang-starts no)
	(mual-starts no)
	(detakJantung-starts no)
	(not (result?))
	
	=>
	(assert (result "Selamat, anda tidak teridentifikasi mengidap hipertensi"))
	(assert (suggestion "Walaupun begitu, tetap perhatikan gaya hidup mu, jauhi segala hal yang dapat menimbulkan hipertensi."))
)


;; @RESULT
(defrule print-result ""
   (declare (salience 10))
   (result ?hasil)
   (suggestion ?rekomendasi)
=>
   (println 
      crlf "Hasil: " ?hasil
	  crlf "Rekomendasi: " ?rekomendasi
   )
)