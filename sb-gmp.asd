(defsystem :sb-gmp
  :name "SB-GMP"
  :description "bignum calculations for SBCL using the GMP library"
  :serial t
  :components ((:module sb-gmp
                :pathname ""
                :components ((:file "gmp")))))

