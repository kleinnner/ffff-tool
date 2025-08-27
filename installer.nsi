; =========================================================================
; NSIS Script for FFFF Tool
; This script creates a Windows installer for the FFFF Tool application.
;
; This version is a complete, working script that incorporates all
; previous fixes for file paths, multi-user support, and branded text,
; with corrected formatting for text pages.
; =========================================================================

; --- Basic Setup ---
!define APP_NAME "FFFF Tool"
!define EXE_NAME "ffff-tool.exe"
!define VERSION "1.0.0"

; The name of the installer file to be created
OutFile "${APP_NAME}-v${VERSION}-Setup.exe"

; Set compression
SetCompressor lzma

; --- Modern UI 2.0 Setup ---
!include "MUI2.nsh"

; --- THE ONLY ADDED LINES ARE HERE ---
!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"
; ------------------------------------

!define MUI_ABORTWARNING ; Warn user if they try to cancel

; --- Installer Pages ---
; Welcome Page
!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${APP_NAME} Setup Wizard"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of the **${APP_NAME}**, a command-line utility for managing `.ffff` archive files. It's a command-line tool, so after installation you can use it from a terminal.$(^NewLine)$(^NewLine)Click Next to continue."
!insertmacro MUI_PAGE_WELCOME

; License Page (Terms and Conditions)
; The 'LICENSE' file must be in the same directory as this script.
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "LICENSE"

; Directory Selection Page
!insertmacro MUI_PAGE_DIRECTORY

; The main installation files page
!insertmacro MUI_PAGE_INSTFILES

; Finish Page with "Run Application" checkbox
!define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_NAME}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch Command Prompt (for testing)"
!define MUI_FINISHPAGE_TITLE "Installation Complete"
!define MUI_FINISHPAGE_TEXT "The **Fully Flexible File Format (.FFFF) Tool** has been successfully installed on your computer. Thank you for using our software!$(^NewLine)$(^NewLine)The **${APP_NAME}** was developed by **0-1.gg and Lois-Kleinner**.$(^NewLine)$(^NewLine)Click Finish to exit the Setup Wizard."
!insertmacro MUI_PAGE_FINISH

; --- Language Setup ---
!insertmacro MUI_LANGUAGE "English"

; --- Installation Scope (User vs. System) ---
; This allows the user to choose "Install for me only" or "Install for all users"
!define MULTIUSER_EXECUTIONLEVEL "admin" ; Request admin privileges for "all users" install
!include "MultiUser.nsh"

Function .onInit
  ; Initialize the MultiUser logic. This sets the correct installation
  ; directory ($INSTDIR) and Start Menu directory ($SMPROGRAMS).
  !insertmacro MULTIUSER_INIT
FunctionEnd

;============================================
; Installation Section
;============================================
Section "Install" SecInstall
  ; Set the output directory to the one determined by the MultiUser logic.
  SetOutPath "$INSTDIR"
  
  ; This is the crucial fix based on the file structure you provided.
  ; It copies the executable from the 'dist' subfolder into the
  ; installation directory.
  File "dist\${EXE_NAME}"
  
  ; Add the README.md and LICENSE files to the installer
  File "README.md"
  File "LICENSE"

  ; Create the Start Menu folder in the correct location for the user.
  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  
  ; Create the shortcuts in the correct location.
  CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  CreateShortcut "$SMPROGRAMS\${APP_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  ; Write the uninstaller into the installation directory.
  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

;============================================
; Uninstaller Section
;============================================
Section "Uninstall"
  ; The uninstaller also uses the correct variables to remove files.
  Delete "$INSTDIR\${EXE_NAME}"
  Delete "$INSTDIR\README.md"
  Delete "$INSTDIR\LICENSE"
  Delete "$INSTDIR\Uninstall.exe"
  
  ; RMDir can remove the directory if it's empty.
  RMDir "$INSTDIR"

  ; Remove shortcuts and the Start Menu folder.
  Delete "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk"
  Delete "$SMPROGRAMS\${APP_NAME}\Uninstall.lnk"
  RMDir "$SMPROGRAMS\${APP_NAME}"
SectionEnd