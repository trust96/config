#!/usr/bin/env pwsh
#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot

# Mapping: repo_file -> target_path (Windows)
$FileMap = @{
  "gitconfig"        = Join-Path $HOME ".gitconfig"
  "wezterm.lua"      = Join-Path $HOME ".config" "wezterm" "wezterm.lua"
  "nvim"             = Join-Path $env:LOCALAPPDATA "nvim"
  "pwsh_profile.ps1" = $PROFILE.CurrentUserAllHosts
}

function Link-File {
  param(
    [string]$Src,
    [string]$Dest
  )

  # Skip if symlink already points to the correct target
  $destItem = Get-Item -Path $Dest -ErrorAction SilentlyContinue
  if ($destItem -and ($destItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
    $currentTarget = $destItem.Target
    $resolvedSrc = (Resolve-Path $Src -ErrorAction SilentlyContinue).Path
    if ($currentTarget -eq $resolvedSrc) {
      Write-Host "skip: $Dest -> already linked"
      return
    }
  }

  # Ensure parent directory exists
  $parentDir = Split-Path -Parent $Dest
  if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
  }

  # If backup already exists, remove it before creating a new one
  $backup = "${Dest}.bak"
  if (Test-Path $backup) {
    Write-Host "remove existing backup: $backup"
    Remove-Item -Recurse -Force $backup
  }

  # Back up existing file/directory
  if (Test-Path $Dest) {
    Write-Host "backup: $Dest -> $backup"
    Move-Item -Path $Dest -Destination $backup
  }

  # Use junction for directories (no admin required), symlink for files
  $itemType = if (Test-Path $Src -PathType Container) { "Junction" } else { "SymbolicLink" }
  New-Item -ItemType $itemType -Path $Dest -Target $Src | Out-Null
  Write-Host "link: $Dest -> $Src"
}

Write-Host "Installing dotfiles from $ScriptDir"
Write-Host "---"

foreach ($file in $FileMap.Keys) {
  $src = Join-Path $ScriptDir $file
  Link-File -Src $src -Dest $FileMap[$file]
}

Write-Host "---"
Write-Host "Done!"
