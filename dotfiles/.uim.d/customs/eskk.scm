;; g:eskk_revert_henkan_style = "eskk"
;; http://github.com/tyru/eskk.vim/commit/a962f27d868c902415c364df8a7cb0d0d8018bcc
;; Thank you very much, tyru!
(define skk-back-to-kanji-state
  (lambda (sc)
    (let ((skk (lambda (sc)
                 (skk-context-set-state! sc 'skk-state-kanji)
                 (skk-context-set-okuri-head! sc "")
                 (if (not (null? (skk-context-okuri sc)))
                   (begin
                     (skk-context-set-head! sc
                                            (append (skk-context-okuri sc)
                                                    (skk-context-head sc)))
                     (skk-reset-dcomp-word sc)))
                 (if (not (null? (skk-context-appendix sc)))
                   (begin
                     (skk-context-set-head! sc
                                            (append (skk-context-appendix sc)
                                                    (skk-context-head sc)))
                     (skk-reset-dcomp-word sc)))
                 (skk-context-set-okuri! sc '())
                 (skk-context-set-appendix! sc '())))
          (eskk (lambda (sc)
                  (let ((x (skk-context-okuri-head sc))
                        (rkc (skk-context-rk-context sc)))
                    (rk-push-key! rkc x)
                    (skk-context-set-okuri! sc '())
                    (skk-context-set-state! sc 'skk-state-okuri))))
          (eskk? (lambda (sc)
                   (and (not (null? (skk-context-okuri sc)))
                        (not (member (skk-context-okuri-head sc)
                                     '("a" "e" "i" "o" "u")))))))
      (skk-reset-candidate-window sc)
      (cond ((eskk? sc) (eskk sc))
            (#t (skk sc))))
    ;; don't clear dcomp (not compatible with ddskk's behavior)
    ;;(skk-reset-dcomp-word sc )
    (skk-context-set-nr-candidates! sc 0)))

