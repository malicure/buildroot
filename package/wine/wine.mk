################################################################################
#
# wine
#
################################################################################

# In Buildroot, Wine should be updated only on "stable" versions. This
# usually corresponds to version "X.0" (for initial stable releases)
# or "X.0.y" (for maintenance releases). Please avoid updating to a
# development version, unless it is absolutely needed (for example:
# incompatibility with another library and no maintenance stable
# version is available).
WINE_VERSION = 10.0
WINE_SOURCE = wine-$(WINE_VERSION).tar.xz
WINE_SITE = https://dl.winehq.org/wine/source/10.0
WINE_LICENSE = LGPL-2.1+
WINE_LICENSE_FILES = COPYING.LIB LICENSE
WINE_CPE_ID_VENDOR = winehq
WINE_SELINUX_MODULES = wine
WINE_DEPENDENCIES = host-bison host-flex host-wine
HOST_WINE_DEPENDENCIES = host-bison host-flex

# Wine needs its own directory structure and tools for cross compiling
WINE_CONF_OPTS = \
	--with-wine-tools=../host-wine-$(WINE_VERSION) \
	--disable-tests \
	--disable-win64 \
	--without-capi \
	--without-coreaudio \
	--without-gettext \
	--without-gettextpo \
	--without-gphoto \
	--without-mingw \
	--without-opencl \
	--without-oss \
	--without-vulkan \
	--without-osmesa  # BR2_PACKAGE_MESA3D_OSMESA_GALLIUM removed in mesa 25.1

# Wine uses a wrapper around gcc, and uses the value of --host to
# construct the filename of the gcc to call.  But for external
# toolchains, the GNU_TARGET_NAME tuple that we construct from our
# internal variables may differ from the actual gcc prefix for the
# external toolchains. So, we have to override whatever the gcc
# wrapper believes what the real gcc is named, and force the tuple of
# the external toolchain, not the one we compute in GNU_TARGET_NAME.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
WINE_CONF_OPTS += TARGETFLAGS="-b $(TOOLCHAIN_EXTERNAL_PREFIX)"
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
WINE_CONF_OPTS += --with-alsa
WINE_DEPENDENCIES += alsa-lib
else
WINE_CONF_OPTS += --without-alsa
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
WINE_CONF_OPTS += --with-cups
WINE_DEPENDENCIES += cups
WINE_CONF_ENV += CUPS_CONFIG=$(STAGING_DIR)/usr/bin/cups-config
else
WINE_CONF_OPTS += --without-cups
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
WINE_CONF_OPTS += --with-dbus
WINE_DEPENDENCIES += dbus
else
WINE_CONF_OPTS += --without-dbus
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
WINE_CONF_OPTS += --with-ffmpeg
WINE_DEPENDENCIES += ffmpeg
else
WINE_CONF_OPTS += --without-ffmpeg
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
WINE_CONF_OPTS += --with-fontconfig
WINE_DEPENDENCIES += fontconfig
else
WINE_CONF_OPTS += --without-fontconfig
endif

# To support freetype in wine we also need freetype in host-wine for the cross compiling tools
ifeq ($(BR2_PACKAGE_FREETYPE),y)
WINE_CONF_OPTS += --with-freetype
HOST_WINE_CONF_OPTS += --with-freetype
WINE_DEPENDENCIES += freetype
HOST_WINE_DEPENDENCIES += host-freetype
WINE_CONF_ENV += FREETYPE_CONFIG=$(STAGING_DIR)/usr/bin/freetype-config
else
WINE_CONF_OPTS += --without-freetype
HOST_WINE_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WINE_CONF_OPTS += --with-gnutls
WINE_DEPENDENCIES += gnutls
else
WINE_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
WINE_CONF_OPTS += --with-gstreamer
WINE_DEPENDENCIES += gst1-plugins-base
else
WINE_CONF_OPTS += --without-gstreamer
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
WINE_CONF_OPTS += --with-opengl
WINE_DEPENDENCIES += libgl
else
WINE_CONF_OPTS += --without-opengl
endif

ifeq ($(BR2_PACKAGE_LIBKRB5),y)
WINE_CONF_OPTS += --with-krb5
WINE_DEPENDENCIES += libkrb5
else
WINE_CONF_OPTS += --without-krb5
endif

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
WINE_CONF_OPTS += --with-pcap
WINE_DEPENDENCIES += libpcap
else
WINE_CONF_OPTS += --without-pcap
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
WINE_CONF_OPTS += --with-usb
WINE_DEPENDENCIES += libusb
else
WINE_CONF_OPTS += --without-usb
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
WINE_CONF_OPTS += --with-v4l2
WINE_DEPENDENCIES += libv4l
else
WINE_CONF_OPTS += --without-v4l2
endif

ifeq ($(BR2_PACKAGE_PCSC_LITE),y)
WINE_CONF_OPTS += --with-pcsclite
WINE_DEPENDENCIES += pcsc-lite
else
WINE_CONF_OPTS += --without-pcsclite
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
WINE_CONF_OPTS += --with-pulse
WINE_DEPENDENCIES += pulseaudio
else
WINE_CONF_OPTS += --without-pulse
endif

ifeq ($(BR2_PACKAGE_SAMBA4),y)
WINE_CONF_OPTS += --with-netapi
WINE_DEPENDENCIES += samba4
else
WINE_CONF_OPTS += --without-netapi
endif

ifeq ($(BR2_PACKAGE_SANE_BACKENDS),y)
WINE_CONF_OPTS += --with-sane
WINE_DEPENDENCIES += sane-backends
WINE_CONF_ENV += SANE_CONFIG=$(STAGING_DIR)/usr/bin/sane-config
else
WINE_CONF_OPTS += --without-sane
endif

ifeq ($(BR2_PACKAGE_SDL2),y)
WINE_CONF_OPTS += --with-sdl
WINE_DEPENDENCIES += sdl2
else
WINE_CONF_OPTS += --without-sdl
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
WINE_CONF_OPTS += --with-udev
WINE_DEPENDENCIES += udev
else
WINE_CONF_OPTS += --without-udev
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
WINE_CONF_OPTS += --with-wayland
WINE_DEPENDENCIES += wayland
else
WINE_CONF_OPTS += --without-wayland
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
WINE_CONF_OPTS += --with-x
WINE_DEPENDENCIES += xlib_libX11
else
WINE_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
WINE_CONF_OPTS += --with-xcomposite
WINE_DEPENDENCIES += xlib_libXcomposite
else
WINE_CONF_OPTS += --without-xcomposite
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
WINE_CONF_OPTS += --with-xcursor
WINE_DEPENDENCIES += xlib_libXcursor
else
WINE_CONF_OPTS += --without-xcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT),y)
WINE_CONF_OPTS += --with-xshape --with-xshm
WINE_DEPENDENCIES += xlib_libXext
else
WINE_CONF_OPTS += --without-xshape --without-xshm
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
WINE_CONF_OPTS += --with-xfixes
WINE_DEPENDENCIES += xlib_libXfixes
else
WINE_CONF_OPTS += --without-xfixes
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
WINE_CONF_OPTS += --with-xinput --with-xinput2
WINE_DEPENDENCIES += xlib_libXi
else
WINE_CONF_OPTS += --without-xinput --without-xinput2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
WINE_CONF_OPTS += --with-xinerama
WINE_DEPENDENCIES += xlib_libXinerama
else
WINE_CONF_OPTS += --without-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
WINE_CONF_OPTS += --with-xrandr
WINE_DEPENDENCIES += xlib_libXrandr
else
WINE_CONF_OPTS += --without-xrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
WINE_CONF_OPTS += --with-xrender
WINE_DEPENDENCIES += xlib_libXrender
else
WINE_CONF_OPTS += --without-xrender
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
WINE_CONF_OPTS += --with-xxf86vm
WINE_DEPENDENCIES += xlib_libXxf86vm
else
WINE_CONF_OPTS += --without-xxf86vm
endif

# host-gettext is essential for .po file support in host-wine wrc
ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
HOST_WINE_DEPENDENCIES += host-gettext
HOST_WINE_CONF_OPTS += --with-gettext --with-gettextpo
else
HOST_WINE_CONF_OPTS += --without-gettext --without-gettextpo
endif

# Wine needs to enable 64-bit build tools on 64-bit host
ifeq ($(HOSTARCH),x86_64)
HOST_WINE_CONF_OPTS += --enable-win64
endif

# Wine only needs the host tools to be built, so cut-down the
# build time by building just what we need.
define HOST_WINE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) __tooldeps__
endef

# Wine only needs its host variant to be built, not that it is
# installed, as it uses the tools from the build directory. But
# we have no way in Buildroot to state that a host package should
# not be installed. So, just provide an noop install command.
define HOST_WINE_INSTALL_CMDS
	:
endef

# We are focused on the cross compiling tools, disable everything else
HOST_WINE_CONF_OPTS += \
	--disable-tests \
	--disable-win16 \
	--without-alsa \
	--without-capi \
	--without-coreaudio \
	--without-cups \
	--without-dbus \
	--without-ffmpeg \
	--without-fontconfig \
	--without-gphoto \
	--without-gnutls \
	--without-gssapi \
	--without-gstreamer \
	--without-krb5 \
	--without-mingw \
	--without-netapi \
	--without-opencl \
	--without-opengl \
	--without-osmesa \
	--without-oss \
	--without-pcap \
	--without-pcsclite \
	--without-pulse \
	--without-sane \
	--without-sdl \
	--without-udev \
	--without-usb \
	--without-v4l2 \
	--without-vulkan \
	--without-wayland \
	--without-x \
	--without-xcomposite \
	--without-xcursor \
	--without-xfixes \
	--without-xinerama \
	--without-xinput \
	--without-xinput2 \
	--without-xrandr \
	--without-xrender \
	--without-xshape \
	--without-xshm \
	--without-xxf86vm

$(eval $(autotools-package))
$(eval $(host-autotools-package))
