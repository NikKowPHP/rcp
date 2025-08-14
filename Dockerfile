# Use a 64-bit Ubuntu image as the base
FROM ubuntu:18.04

# Set a working directory inside the container
WORKDIR /app

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# --- ENABLE 32-BIT ARCHITECTURE AND INSTALL 32-BIT LIBRARIES ---

# 1. Add the i386 (32-bit) architecture
RUN dpkg --add-architecture i386

# 2. Update package lists for the standard 18.04 repos
RUN apt-get update

# 3. Add the Ubuntu 16.04 (Xenial) repository to find the old libpng12 package
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" > /etc/apt/sources.list.d/xenial-security.list && \
    apt-get update

# 4. Install all required 32-bit libraries, including the one from the old repo.
#    Note the ":i386" suffix on each package name.
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
    && rm -rf /var/lib/apt/lists/*

# --- FIX for shared libraries ---
# The application requires older versions of some libraries.
# We create symbolic links from the expected names to the available libraries.
# NOTE: The target for libexpat.so.1 is in /lib/, not /usr/lib/
RUN ln -s /usr/lib/i386-linux-gnu/libnotify.so.4 /usr/lib/i386-linux-gnu/libnotify.so.1
RUN ln -s /lib/i386-linux-gnu/libexpat.so.1 /lib/i386-linux-gnu/libexpat.so.0

# Rebuild the dynamic linker's cache to recognize the new links
RUN ldconfig

# Copy the executable file into the container
COPY GrafikRCP /app/GrafikRCP

# Ensure the file is executable
RUN chmod +x /app/GrafikRCP

# Set the command to run when the container starts
CMD ["./GrafikRCP"]