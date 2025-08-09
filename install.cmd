@set scoop_buckets=^
  extras


@for %%i in (%scoop_buckets%) do @(
    scoop bucket list | findstr /i "%%i" >nul || (
        echo Adding bucket: %%i
        scoop bucket add %%i
    )
)

@set scoop_packages=^
  7zip^
  fzf^
  sudo^
  television^
  zoxide

@for %%i in (%scoop_packages%) do scoop install %%i 2>nul
