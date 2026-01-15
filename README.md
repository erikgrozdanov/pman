# 🚀 pman - Your Easy-to-Use Project Manager

![Download pman](https://img.shields.io/badge/Download%20pman-Click%20Here-blue)

## 📋 Description

pman is a lightweight, interactive bash-based project manager designed for local development using Podman Pods on Fedora. It simplifies the process of creating and managing your projects, especially for frameworks like WordPress and Laravel. With rootless security and SELinux compatibility, pman ensures a safe development environment.

## 🔍 Features

- **Interactive Bash Interface:** Easy-to-use shell commands that guide you through project management.
- **Automated Scaffolding:** Quickly set up WordPress and Laravel projects with simple commands.
- **Rootless Security:** Develop without needing root access, enhancing security.
- **SELinux Compatibility:** Works smoothly with Fedora's SELinux, making it suitable for secure environments.
- **Lightweight Design:** Fast and efficient, minimizing resource usage while maximizing productivity.

## ⚙️ System Requirements

To run pman, your system must meet the following requirements:

- **Operating System:** Fedora 33 or later.
- **Podman:** Ensure Podman is installed on your system; it can be installed via your package manager.
- **Bash:** A working installation of Bash is needed to run the scripts.

## 🚀 Getting Started

Follow these steps to download and set up pman on your computer.

1. **Visit the Download Page:**
   Click the link below to go straight to the pman Releases page.

   [Download pman](https://github.com/erikgrozdanov/pman/releases)

2. **Choose the Latest Release:**
   On the Releases page, find the latest release of pman. Look for version numbers that are marked as "Latest Release."

3. **Download the Package:**
   Click on the package suitable for your system. This will typically be a `.tar.gz` file. The file contains everything you need to get started.

4. **Extract the Package:**
   Once the download completes, locate the `.tar.gz` file in your Downloads folder. Open a terminal and run the following command to extract the package:

   ```bash
   tar -xvzf pman-x.y.z.tar.gz
   ```

   Replace `x.y.z` with the actual version number of the downloaded file.

5. **Navigate to the pman Directory:**
   Change your directory to the extracted pman folder:

   ```bash
   cd pman-x.y.z
   ```

6. **Run the Installation Script:**
   In the pman directory, run the installation script by typing:

   ```bash
   ./install.sh
   ```

   Follow any prompts to complete the installation.

7. **Start Using pman:**
   Launch pman by typing:

   ```bash
   pman
   ```

   This command opens the interactive interface where you can start managing your projects.

## 💡 Basic Usage

Once you've launched pman, you can start using it to create new projects. Here are a few basics:

- **To create a new WordPress project:**

   ```bash
   pman create wordpress my-wordpress-site
   ```

   This command sets up a new WordPress project called "my-wordpress-site."

- **To create a new Laravel project:**

   ```bash
   pman create laravel my-laravel-app
   ```

   This will initialize a new Laravel project named "my-laravel-app."

- **To see a list of your projects:**

   ```bash
   pman list
   ```

   This command displays all projects managed by pman.

## ⚙️ Troubleshooting

If you run into issues during installation or while using pman, consider the following steps:

1. **Check System Requirements:** Ensure your operating system and Podman installation match the required versions.
2. **Look at Terminal Messages:** Pay attention to error messages in your terminal. They often provide clues on what's wrong.
3. **Re-Download and Extract:** If the package seems corrupted, re-download it and redo the extraction process.

## 🛠️ Getting Help

If you need further assistance or want to provide feedback, reach out through the Issues section on the [pman GitHub page](https://github.com/erikgrozdanov/pman/issues).

## 🚀 Download & Install

Ready to take control of your local development? Click the button below to start:

[Download pman](https://github.com/erikgrozdanov/pman/releases) 

Enjoy streamlined project management with pman today!