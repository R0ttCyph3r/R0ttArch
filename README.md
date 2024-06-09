# R0ttArch (for bare metal with nvidia)

![R0ttArch](https://github.com/R0ttCyph3r/R0ttArch/blob/main/R0ttArch.png)

**Before using this repo I assume you already know somewhat of bspwm and using arch for a reasonable amount of time. This repo is for the purpose of automating installation of tools and some configs.**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/R0ttCyph3r/R0ttArch/main/installer.sh)"
```

These are some important key bindings rest you can read from sxhkdrc.

| Keys                                               | Action                   |
| :------------------------------------------------- | :----------------------- |
| <kbd>super</kbd> + <kbd>Enter</kbd>                | Open a terminal          |
| <kbd>super</kbd> + <kbd>@space</kbd>               | Apps Menu.               |
| <kbd>super</kbd> + <kbd>alt</kbd> + <kbd>r</kbd>   | Restart bspwm.           |
| <kbd>super</kbd> + <kbd>q</kbd>                    | Quit current window      |
| <kbd>super</kbd> + <kbd>left arrow</kbd> <kbd>right arrow</kbd>     | Switch between workspace |
| <kbd>super</kbd> + <kbd>shift</kbd> + <kbd>s</kbd> | Screenshot               |

Do following changes:

- /etc/sudoers.d/ (there's a file in this directory delete it)

- /etc/sudoers

```
uncomment
# %Wheel ALL=(ALL:ALL) ALL
%Wheel ALL=(ALL:ALL) ALL
```

- you need to downgrade `ruby-json` package for wpscan to work perfectly

```
sudo downgrade ruby-json
```

from the options select 9th which is `2.6.3` version and hit enter it will ask to add this package to `Ignored Packages` choose yes.

Also add `burpsuite` to `Ignored Packages` in `/etc/pacman.conf` like below.

![image](https://github.com/R0ttCyph3r/R0ttArch/assets/146866845/eb696c80-8264-428c-9b7a-7bc99a26718f)


| Tools               | Description       |
|---------------------|-------------------|
| nmap                | Network scanner   |
| hashcat             | Password cracker  |
| dirsearch           | Directory bruteforcer |
| feroxbuster         | Directory and subdomain bruteforcer |
| john the ripper     | Password cracker  |
| docker docker-compose | Containerization platform |
| git                 | Version control system |
| gobuster            | Directory and DNS bruteforcer |
| ffuf                | Fast web fuzzer   |
| python2 python3     | Python interpreters |
| neovim              | Text editor       |
| mariadb             | Relational database |
| qemu                | Virtualization platform |
| tcpdump             | Network packet analyzer |
| wireshark           | Network protocol analyzer |
| openvpn             | VPN client        |
| sqlmap              | SQL injection tool |
| dbeaver             | Database tool     |
| hydra               | Password cracker  |
| rlwrap              | Readline wrapper  |
| nc                  | Netcat            |
| proxychains-ng      | Proxy tool        |
| sshpass             | SSH automation tool |
| sshuttle            | VPN over SSH      |
| socat               | Network utility   |
| exploitdb           | Exploit database  |
| metasploit          | Penetration testing framework |
| evil-winrm          | WinRM shell       |
| impacket            | Python library for working with network protocols |
| netexec             | Tool for executing commands on multiple hosts |
| burpsuite           | Web application security testing tool |
| bloodhound          | Active Directory reconnaissance tool |
| pypykatz            | Mimikatz implementation in Python |
| rustscan            | Fast port scanner |
| wpscan              | WordPress vulnerability scanner |
| seclists            | Collection of security lists |
| havoc-c2            | Command and control framework |
| sliver-c2           | Cross-platform implant framework |


![image](https://github.com/R0ttCyph3r/R0ttArch/assets/146866845/2526ed8c-287b-4c6d-8a17-600043773c1a)

![image](https://github.com/R0ttCyph3r/R0ttArch/assets/146866845/5440e43f-ddc9-4ad4-820d-646070d25dbd)

![image](https://github.com/R0ttCyph3r/R0ttArch/assets/146866845/d2b294e0-c3ae-4ebf-99e3-72095b842c60)

Check out [NvChad](https://nvchad.com/docs/quickstart/install/) if you want nvim like me 
