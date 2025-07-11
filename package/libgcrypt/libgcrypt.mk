################################################################################
#
# libgcrypt
#
################################################################################

LIBGCRYPT_VERSION = 1.11.1
LIBGCRYPT_SOURCE = libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_LICENSE = LGPL-2.1+
LIBGCRYPT_LICENSE_FILES = COPYING.LIB
LIBGCRYPT_SITE = https://gnupg.org/ftp/gcrypt/libgcrypt
LIBGCRYPT_INSTALL_STAGING = YES
LIBGCRYPT_DEPENDENCIES = libgpg-error
LIBGCRYPT_CONFIG_SCRIPTS = libgcrypt-config
LIBGCRYPT_CPE_ID_VENDOR = gnupg

# Patching configure.ac and Makefile.am in 0001
LIBGCRYPT_AUTORECONF = YES
LIBGCRYPT_CONF_ENV += GPGRT_CONFIG=$(STAGING_DIR)/usr/bin/gpgrt-config
LIBGCRYPT_CONF_OPTS = \
	--disable-tests \
	$(if $(BR2_OPTIMIZE_0),--disable-ppc-crypto-support,) \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

# disable asm for broken archs
ifeq ($(BR2_i386)$(BR2_m68k_cf),y)
LIBGCRYPT_CONF_OPTS += --disable-asm
endif

# Code doesn't build in thumb mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
LIBGCRYPT_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -marm"
endif

HOST_LIBGCRYPT_DEPENDENCIES = host-libgpg-error
HOST_LIBGCRYPT_CONF_OPTS = \
	--disable-tests \
	--with-gpg-error-prefix=$(HOST_DIR)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
