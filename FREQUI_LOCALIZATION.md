# Localized FreqUI

This repository tracks the customized FreqUI source as the `freqtrade-ui`
submodule. The submodule points to `Arthurrr29/frequi` and follows the
`codex/zh-cn-i18n` branch.

Clone the full project with its UI source:

```powershell
git clone --recurse-submodules https://github.com/Arthurrr29/freqtrade.git
```

For an existing clone, initialize or refresh the UI source:

```powershell
git submodule update --init --recursive
```

Build and install FreqUI into Freqtrade's API server:

```powershell
.\install-frequi.ps1
```

Use `-SkipInstall` when the pinned dependencies are already installed. The
installed web assets are generated files and remain ignored by Git; the source
of truth is the `freqtrade-ui` submodule.

The UI selects Chinese or English from the browser language on first use. The
selection can then be changed and persisted from FreqUI Settings.
