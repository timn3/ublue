# ublue os fork

My own Linux "distro". 
Experimentation lab and testing ground based on Fedora Bootc.

## Installation

Install Ublue ISO using the provided Anaconda installer

### First boot
After installing, enroll your TPM2 chip for automatic disk unlock:
    `sudo ublue-tpm2-enroll`
the Anaconda passphrase remains a working fallback.

## References
I used the following sources:

- https://bootc-dev.github.io/bootc
- https://docs.fedoraproject.org/en-US/bootc

And took a lot of inspiration (and code) from the following projects:
- https://github.com/ublue-os/bluefin-lts
- https://github.com/ublue-os/main
- https://gitlab.com/fedora/bootc/examples

Special credit to the blog and talks by [Ben Breard][] and the countless examples surrounding the [Universal Blue][] project.

[Ben Breard]: https://mrguitar.net
[Universal Blue]: https://universal-blue.org/
