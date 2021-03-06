;;this is the theme that I created specifically for emacs-nox

;;THEME
(setq my-white    "#ffffff")
(setq my-black    "#000000")
(setq my-red      "#ff0000")
(setq my-cyan     "#0087d7")
(setq my-green    "#03fc94")
(setq my-purple   "#cd75ff")
(setq my-orange   "#ffa500")
(setq my-pink     "#ff7efd")
(setq my-yellow   "#f4ff5c")
(setq my-brown    "#af5f00")
(setq my-grey     "#8f8c8c")
(setq my-darkgrey "#3e4446")
;general
(set-face-attribute 'default nil                      :foreground my-white)
(set-face-attribute 'font-lock-comment-face nil       :foreground my-grey)
(set-face-attribute 'font-lock-string-face nil        :foreground my-red)
(set-face-attribute 'font-lock-constant-face nil      :foreground my-yellow)
(set-face-attribute 'font-lock-keyword-face nil       :foreground my-green)
(set-face-attribute 'font-lock-builtin-face nil       :foreground my-purple)
(set-face-attribute 'font-lock-type-face nil          :foreground my-orange)
(set-face-attribute 'line-number nil                  :foreground my-cyan  :weight 'bold)
(set-face-attribute 'font-lock-function-name-face nil :foreground my-pink  :weight 'bold)
(set-face-attribute 'font-lock-variable-name-face nil :foreground my-cyan  :weight 'bold)
(set-face-attribute 'mode-line nil                    :foreground my-white :background my-darkgrey)
(set-face-attribute 'mode-line-inactive nil                                :background my-grey)
(set-face-attribute 'hl-line nil                                           :background my-darkgrey)
;magit
(set-face-attribute 'magit-section-heading nil    :foreground my-cyan)
(set-face-attribute 'magit-branch-remote nil      :foreground my-green)
(set-face-attribute 'magit-branch-remote-head nil :foreground my-green)
(set-face-attribute 'magit-branch-current nil     :foreground my-red)
(set-face-attribute 'magit-branch-local nil       :foreground my-red)
;org
(set-face-attribute 'org-level-1 nil         :foreground my-purple)
(set-face-attribute 'org-level-2 nil         :foreground my-cyan)
(set-face-attribute 'org-level-3 nil         :foreground my-green)
(set-face-attribute 'org-level-4 nil         :foreground my-red)
(set-face-attribute 'org-level-5 nil         :foreground my-pink)
(set-face-attribute 'org-level-6 nil         :foreground my-grey)
(set-face-attribute 'org-level-7 nil         :foreground my-yellow)
(set-face-attribute 'org-level-8 nil         :foreground my-brown)
(set-face-attribute 'org-done nil            :foreground my-green)
(set-face-attribute 'org-todo nil            :foreground my-red)
(set-face-attribute 'org-priority nil        :foreground my-cyan)
(set-face-attribute 'org-special-keyword nil :foreground my-grey)
(set-face-attribute 'org-headline-done nil   :foreground my-green)
;mu4e
(set-face-attribute 'mu4e-title-face nil   :foreground my-cyan :weight 'bold)
(set-face-attribute 'mu4e-header-title-face nil   :foreground my-red)
(set-face-attribute 'mu4e-header-value-face nil   :foreground my-red)
(set-face-attribute 'mu4e-header-key-face nil   :foreground my-green)
(set-face-attribute 'mu4e-replied-face nil   :foreground my-purple)
(set-face-attribute 'mu4e-flagged-face nil   :foreground my-cyan)
