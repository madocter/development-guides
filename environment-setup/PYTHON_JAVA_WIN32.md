
# Linux Bash and tools for Windows

### Gitbash
Is like a virtual unix execution environment running on Windows host, it has own virtual space and shared space with Windows.

Install GIT bash + GIT: https://git-scm.com/install/windows a good way to install gitbash is to also install GIT which offer you Gitbash installation.

Recommended Github desktop available for Linux/Windows:
https://docs.github.com/en/desktop/installing-and-authenticating-to-github-desktop/installing-github-desktop?platform=windows

#### Unix tools: zip
This is necessary for your Git bash environment

```bash
winget install -e --id GnuWin32.Zip
mkdir ~/bin
cp /usr/bin/unzip ~/bin/zip
```

### WSL
Windows Subsystem for Linux

https://learn.microsoft.com/en-us/windows/wsl/install


### Chocolatey
Package and software management tool for installing software in Windows:
https://docs.chocolatey.org/en-us/chocolatey-components-dependencies-and-support-lifecycle/#supported-windows-versions

Some software is available on chocolatey so its worth.

# Python

Pyenv to manage different Python versions:

Windows:
https://github.com/pyenv-win/pyenv-win

Linux:
https://github.com/pyenv/pyenv

Example:
```bash
pyenv install 3.9
pyenv global 3.9
```

# Node and NPM
You can use NVM (Node version manager) that allows you to manage different node + npm versions

Usually each node version is binded to a npm version, recall that node is the execution environment and npm is the package manager.

Windows:
https://github.com/coreybutler/nvm-windows

Linux:
https://github.com/nvm-sh/nvm

**Note:** Is not available on ubuntu repositories son need pull from GIT and install using the readme instructions, not possible with apt, snap, or other linux packages management system.

# Java

Sdkman to manage different Java versions: https://sdkman.io/install/

Install:
```bash
curl -s "https://beta.sdkman.io" | bash
source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk selfupdate force
```

Install and list java versions:
```bash
sdk list java
sdk use java 17.0.0 tem
```

Then if you need to point java SDK in some tool such as Intellij or Eclipse you can refer to SDK location:

Windows:
`$HOME\.sdkman\candidates\java\current\bin`
note HOME points to: `C:\Users\YOUR_USER\`

Linux:
`~\.sdkman\candidates\java\current\bin`

Advanced system settings / Environment variables.

Add new SYSTEM variable named: `JAVA_HOME` with value `{UNIT}:\Users\{USER}\.sdkman\candidates\java\current`

Is the convention for most of Java based programs.

Then edit PATH system variable, add new entry and set java binary location using the variable: %JAVA_HOME%\bin

Like this can invoke always current Java version you set up with SDK.

*NOTE* Do this with rest of tools, python, go, etc... usually installers do for you.

# GO

Install GO version manager:

https://github.com/andrewkroh/gvm

For WINDOWS 7 / WINDOWS SERVER 2008 need install this patch, since version Go 1.21.5 doesn't support anymore:

https://github.com/stunndard/golangwin7patch



# Win32 .NET framework C++

Suit of tools for execute Win32 api software

* .Netframework
* C++ redistributable 

You can download and install many of the available version it offers great back-guard compatibility unlike Java ecosystem there is no need to switch from one to another version.

