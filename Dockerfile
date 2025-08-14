# Use a 64-bit Ubuntu image as the base
FROM ubuntu:18.04

# Set a working directory inside the container
WORKDIR /app

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# --- ENABLE 32-BIT ARCHITECTURE AND INSTALL 32-BIT LIBRARIES ---

# 1. Add the i386 (32-bit) architecture
RUN dpkg --add-architecture i386

# 2. Update package lists to include the new architecture
RUN apt-get update

# 3. Install the 32-bit versions of the libraries.
#    Note the ":i386" suffix on each package name.
RUN apt-get install -y --no-install-recommends \
    libc6:i386 \
    libstdc++6:i386 \
    libgtk-3-0:i386 \
    libfbclient2:i386 \
    libgtk2.0-0:i386 \
    libxft2:i386 \
    && rm -rf /var/lib/apt/lists/*

# Copy the executable file into the container
COPY GrafikRCP /app/GrafikRCP

# Ensure the file is executable
RUN chmod +x /app/GrafikRCP

# Set the command to run when the container starts
CMD ["./GrafikRCP"]