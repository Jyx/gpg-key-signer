# Simple Makefile to make signing GPG keys slightly easier.
# Author: Joakim Bech (joakim.bech@gmail.com)
# Date:   Tor 14 nov 2013 10:38:18 CET

# Grab your own private key, note that the grep after the sec line expect that
# there is no hash inside (which indicates that your master keys are available).
# The line is constructed and tested for using BASH as shell.
MY_OWN_KEY=$(shell gpg --list-secret-keys | grep -e "^sec " | awk '{print $2}' | sed -e 's/.*\/\(.*\) .*/\1/g')

ifeq ($(strip $(MY_OWN_KEY)),)
$(error Couldn't find the private key that is needed to be able to sign other keys)	
endif

ifeq ($(strip ${GPGKEYTOSIGN}),)
$(error Environment variable GPGKEYTOSIGN isn't set (export GPGKEYTOSIGN=AABBCCDD))
endif

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

get_key:
	gpg --keyserver pgp.mit.edu --recv-keys ${GPGKEYTOSIGN}

check_fpr:
	gpg --fingerprint ${GPGKEYTOSIGN}

sign:
	gpg --sign-key ${GPGKEYTOSIGN}

export:
	gpg --armor --output ${GPGKEYTOSIGN}-signedBy-$(MY_OWN_KEY).asc --export ${GPGKEYTOSIGN}

upload:
	gpg --keyserver pgp.mit.edu --send-key ${GPGKEYTOSIGN}

