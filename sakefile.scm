(define library-modules
  '((sdl2 . "-lSDL2")
    (sdl2-image . "-lSDL2_image")
    (sdl2-mixer . "-lSDL2_mixer")
    (sdl2-ttf . "-lSDL2_ttf")))

(define-task compile ()
  (for-each (lambda (module-info)
              (let ((module (car module-info))
                    (cc-options "-w -I/usr/include/SDL2")
                    (ld-options (cdr module-info)))
                (sake#compile-c-to-o (sake#compile-to-c module compiler-options: '(debug))
                                     cc-options: cc-options
                                     ld-options: ld-options)
                (sake#compile-c-to-o (sake#compile-to-c module)
                                     cc-options: cc-options
                                     ld-options: ld-options)))
            library-modules))

(define-task install ()
  (for-each (lambda (m) (sake#install-compiled-module (car m) versions: '(() (debug)))) library-modules)
  (make-directory "lib/android")
  (copy-file "src/android/libs" "lib/android/libs")
  (sake#install-sphere-to-system))

(define-task uninstall ()
  (sake#uninstall-sphere-from-system))

(define-task all (compile android:compile install)
  'all)
