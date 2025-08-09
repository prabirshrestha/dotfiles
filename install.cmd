@set scoop_packages=^
  sudo^
  zoxide

@for %%i in (%scoop_packages%) do @scoop install %%i 2>nul
