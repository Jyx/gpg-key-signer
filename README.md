gpg-key-signer
==============

Simple Makefile that should make life easier when it comes to sign keys for
other GPG users.

Contents:
1.  Instructions


1.  Instructions
------------
1. export the name path to your GPG folder
     export GNUPGHOME=$HOME/.gnupg

2. export the identifier for the key that you are going to sign
     export GPGKEYTOSIGN=AABBCCDD

3. make help

4. Follow the numbering, step by step according to the output from make help
   (step 1 and 2 should already have been done by now)
