# Use a 64-bit Ubuntu image as the base
FROM ubuntu:18.04

# --- PROXY CONFIGURATION ---
ARG PROXY_URL="http://172.16.2.254:3128"
ENV http_proxy=$PROXY_URL
ENV https_proxy=$PROXY_URL
ENV no_proxy="localhost,127.0.0.1"

# Force APT to use the proxy explicitly
RUN echo "Acquire::http::Proxy \"$PROXY_URL\";" > /etc/apt/apt.conf.d/99proxy && \
    echo "Acquire::https::Proxy \"$PROXY_URL\";" >> /etc/apt/apt.conf.d/99proxy

# Set a working directory inside the container
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive

# Force GTK to use X11 instead of trying Wayland natively, 
# which prevents crashes in older 32-bit toolkits on Wayland hosts.
ENV GDK_BACKEND=x11

# --- ENABLE 32-BIT ARCHITECTURE ---
RUN dpkg --add-architecture i386 && apt-get update

# Add the Ubuntu 16.04 (Xenial) repository for libpng12
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main universe" > /etc/apt/sources.list.d/xenial-security.list && \
    apt-get update

# --- INSTALL 32-BIT LIBRARIES AND GTK MODULES ---
# Added fonts-liberation, dbus, and core X extensions to prevent "Invalid memory access" 
# when the GUI toolkit tries to render text or initialize windows.
RUN apt-get install -y --no-install-recommends \
    libc6:i386 \
    libstdc++6:i386 \
    libgtk-3-0:i386 \
    libfbclient2:i386 \
    libgtk2.0-0:i386 \
    libxft2:i386 \
    libnotify4:i386 \
    libexpat1:i386 \
    libpng12-0:i386 \
    libbz2-1.0:i386 \
    libcanberra-gtk-module:i386 \
    libcanberra-gtk3-module:i386 \
    libatk-bridge2.0-0:i386 \
    libxss1:i386 \
    libsm6:i386 \
    libice6:i386 \
    libxext6:i386 \
    libxrender1:i386 \
    libx11-xcb1:i386 \
    dbus-x11 \
    fonts-liberation \
    adwaita-icon-theme-full \
    && rm -rf /var/lib/apt/lists/*

# --- SHARED LIBRARY LINKS ---
RUN ln -s /usr/lib/i386-linux-gnu/libnotify.so.4 /usr/lib/i386-linux-gnu/libnotify.so.1 || true
RUN ln -s /lib/i386-linux-gnu/libexpat.so.1 /lib/i386-linux-gnu/libexpat.so.0 || true
RUN ldconfig

# Copy and prepare the executable
COPY GrafikRCP /app/GrafikRCP
RUN chmod +x /app/GrafikRCP

CMD ["./GrafikRCP"]