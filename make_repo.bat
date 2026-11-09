@echo off
REM Builds the GitHub repository folder from your Trend1 working folder.
REM Run this from inside D:\My research papers\Emerging trends\Trend1
REM after unzipping vte_github_kit next to it (so ..\vte_github_kit exists).

set KIT=..\vte_github_kit
set REPO=..\verify-then-explain

mkdir %REPO%\scripts %REPO%\results\detectors %REPO%\results\manifests %REPO%\results\evidence %REPO%\results\generations %REPO%\results\verified %REPO%\results\repairs %REPO%\results\sufficiency 2>nul

REM kit files (README, licence, citation, figures, error-injection results)
xcopy /E /Y /I %KIT%\* %REPO%\ >nul
del %REPO%\make_repo.bat

REM scripts
copy /Y step*.py %REPO%\scripts\ >nul
copy /Y download_cic_folder.py %REPO%\scripts\ >nul
copy /Y run_*.bat %REPO%\scripts\ >nul
copy /Y requirements.txt %REPO%\ >nul

REM detectors (models + metrics; small files)
for %%D in (ciciot2023 unsw) do (
  mkdir %REPO%\results\detectors\%%D 2>nul
  copy /Y results\%%D\*.* %REPO%\results\detectors\%%D\ >nul
  mkdir %REPO%\results\manifests\%%D 2>nul
  copy /Y prepared\%%D\manifest.json %REPO%\results\manifests\%%D\ >nul
  mkdir %REPO%\results\evidence\%%D 2>nul
  copy /Y evidence\%%D\*.* %REPO%\results\evidence\%%D\ >nul
  mkdir %REPO%\results\verified\%%D 2>nul
  copy /Y verified\%%D\*.* %REPO%\results\verified\%%D\ >nul
)
copy /Y generations\*.jsonl %REPO%\results\generations\ >nul
copy /Y repairs\*.jsonl %REPO%\results\repairs\ >nul
copy /Y sufficiency\*.jsonl %REPO%\results\sufficiency\ >nul

echo.
echo Repository folder ready: %REPO%
echo Files larger than 25 MB (cannot be uploaded through the website):
forfiles /P %REPO% /S /M *.* /C "cmd /c if @fsize GTR 26214400 echo @path"
echo Done.
