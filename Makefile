# Simple Makefile to make signing GPG keys slightly easier.
# Author: Joakim Bech (joakim.bech@gmail.com)
# Date:   Tor 14 nov 2013 10:38:18 CET

# Grab your own private key, note that the grep after the sec line expect that
# there is no hash inside (which indicates that your master keys are available).
# The line is constructed and tested for using BASH as shell.
MY_OWN_KEY=$(shell gpg --list-secret-keys | grep -e "^sec " | awk '{print $2}' | sed -e 's/.*\/\(.*\) .*/\1/g')

help:
	@echo "     MY_OWN_KEY=$(MY_OWN_KEY)"
	@echo " 1.  export GNUPGHOME=/home/jbech/tmp/.gnupg"
	@echo " 2.  export GPGKEYTOSIGN=AABBCCDD"
	@echo " 3.  make get_key   (gpg --keyserver pgp.mit.edu --recv-keys ${GPGKEYTOSIGN})"
	@echo " 4.  make check_fpr (gpg --fingerprint ${GPGKEYTOSIGN})"
	@echo "      verify that fingerprint is correct"
	@echo " 5.  make sign      (gpg --sign-key ${GPGKEYTOSIGN})"
	@echo " 6a. make export    (gpg --armor --output ${GPGKEYTOSIGN}-signedBy-$(MY_OWN_KEY).asc --export ${GPGKEYTOSIGN})"
	@echo "     or (ask key owner before uploading his/hers key)"
	@echo " 6b. make upload    (gpg --keyserver pgp.mit.edu --send-key ${GPGKEYTOSIGN})"

get_key: check_key_to_sign
	gpg --keyserver pgp.mit.edu --recv-keys ${GPGKEYTOSIGN}

check_fpr: check_key_to_sign
	gpg --fingerprint ${GPGKEYTOSIGN}

sign: check_key_to_sign
	gpg --sign-key ${GPGKEYTOSIGN}

export: check_own_key check_key_to_sign
	gpg --armor --output ${GPGKEYTOSIGN}-signedBy-$(MY_OWN_KEY).asc --export ${GPGKEYTOSIGN}

upload: check_key_to_sign
	gpg --keyserver pgp.mit.edu --send-key ${GPGKEYTOSIGN}

check_own_key:
ifeq ($(strip $(MY_OWN_KEY)),)
	$(info Could not find the private key that is needed to be able to sign other keys)
	$(error Forgot to: export GPGKEYTOSIGN=AABBCCDD?)
endif

check_key_to_sign:
ifeq ($(strip $(GPGKEYTOSIGN)),)
	$(error Environment variable GPGKEYTOSIGN hasn't been set (export GPGKEYTOSIGN=AABBCCDD))
endif
