---
published: false
---

# rtridz'z formulas OSX Install


## Installation

These steps have been tested on Mountain Lion 10.8.4 with Xcode 4.6.3. It is probably a good idea to make sure all OSX updates have been applied and Xcode is up to date. Also, probably good to install the Xcode command line apps as explained over at[Stackoverflow](http://stackoverflow.com/a/932932).

- Install [Homebrew](http://brew.sh/) if you haven't already

  ```sh
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  ```
  or if you already have it installed, update and upgrade everything:
  
  ```sh
  brew update
  brew upgrade
  ```
  
- After that is done run the following to make sure you have no issues with your setup, cleanup anything it catches

  ```sh
  brew doctor
  ```

- Add this line to your profile (ie `~/.profile` or `~/.bash_profile` or `~/.zshenv`) and reload
  your profile (`source ~/.profile` or `exec $SHELL`)

  ```sh
  export PATH=/usr/local/sbin:/usr/local/bin:$PATH
  ```

- Tap formulas

  ```sh
  brew tap rtridz/homebrew
  ```

**Congratulations!!**

Everything should now be working. It is time to give it a try! Below are some of the programs you can try

```sh
brew install [name]
```


- **Uninstall Homebrew**
  If you think you have some cruftiness with Homebrew, this Gist will completely uninstall Homebrew and any libraries it may have installed. Of course if you are using Homebrew for other things you could make a mess of your life. 
  
  This [Gist](https://gist.github.com/mxcl/1173223) is from the [Homebrew FAQ](https://github.com/mxcl/homebrew/wiki/FAQ)
  
  Then finish the clean-up with these steps
  
  ```sh
  rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup
  rm -rf /Library/Caches/Homebrew
  rm -rf /usr/local/lib/python2.7/site-packages
  ```

