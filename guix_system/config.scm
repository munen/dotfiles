;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
             (gnu packages shells))

(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Zurich")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (host-name "media")
  (users (cons* (user-account
                  (name "munen")
                  (comment "Alain M. Lafon")
                  (group "users")
                  (home-directory "/home/munen")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
            (specification->package "i3status")
            (specification->package "dmenu")
            (specification->package "st")
            (specification->package "nss-certs"))
      %base-packages))
  (services (cons*
	      (service openssh-service-type
		       (openssh-configuration
			 (x11-forwarding? #t)
			 (permit-root-login #t) 
			 ;; (permit-root-login 'without-password)
			 ))


	      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "5253e6fa-9322-4b81-b56c-5f82cff50247")))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "E3DC-FFF8" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "4c6778b9-a155-412c-94a2-be6910fef3d0"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
