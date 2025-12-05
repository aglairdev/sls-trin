[![Branch: Accela original](https://img.shields.io/badge/Branch-Accela%20original-blue)](https://github.com/aglairdev/SLStools)

## Updates

- Integração com SLScheevo
- Modificação da interface do Accela para SLStools
- Tradução da interface para pt-BR 🇧🇷
- `PlayNotOwnedGames: yes` setado por padrão
- Atalho na área de trabalho configurado com a variável de ambiente do SLSsteam para evitar erros de inicialização por atalho gerado via apt
- Integração com online-fix

## Requisitos

- `curl`
- Steam nativa (**não** compatível com Flatpak ou Snap)

## Distros testadas

| Distro   | Status |
|----------|:-------: |
| Kubuntu  |   ✅     |
| Zorin    |   ✅     |

## Instalação

```bash
curl -sSL https://raw.githubusercontent.com/aglairdev/SLStools/conquistas/install.sh | bash
```

<p align="center">
  <img src="assets/demo.png" width="400" style="display: inline-block; margin-right: 20px;"/>
  <img src="assets/demo2.png" width="400" style="display: inline-block;"/>
</p>
- [Tutorial em vídeo](https://www.youtube.com/watch?v=fOD65CS8aL4)

## Config

### Depots

- [Ryuu](https://generator.ryuu.lol/)
- [Luatools](https://discord.com/invite/luatools)
> luatools — gen-games-here — [appid]

**Linux:**
> O executável e o launcher (se houver) precisam de permissão de execução manual

**Windows:**
> Ative o Proton (recomenda-se a versão experimental)

### SLScheevo

Abra o SLScheevo pelo menos uma vez para adicionar as credenciais.

### Online-fix

Ative ou desative o checkbox "Ativar online-fix".

### Driver recomendado (Nvidia)
- nvidia-driver-570

## Backup de saves

```bash
cd ~/SLStools/scripts/ludusavi
```
- Descompacte
- Inicie o `ludosavi`

## Backup de conquistas

```bash
cd ~/SLStools/scripts
sudo chmod +x backup-conquistas-steam.sh
./backup-conquistas-steam.sh
```

## Desinstalação

```bash
cd ~/SLStools/scripts
sudo chmod +x uninstall.sh
./uninstall.sh
```

## Fix

<p align="center">
  <img src="assets/fix-comprar.png" width="200"/>
</p>

`~/.config/SLSsteam/config.yaml` — PlayNotOwnedGames: yes

> [!TIP]
> O script atual já faz isso automaticamente

<p align="center">
  <img src="assets/fix-disponivel-para.png" width="200"/>
</p>

Clique com o botão direito do mouse no jogo — Propriedades — Compatibilidade — Forçar uso de ferramenta de compatibilidade do Steam Play específica — Proton Experimental

<p align="center">
  <img src="assets/fix-6:0000065432.png" width="200"/>
</p>

`~/SLStools/scripts/Steamless` — Descompacta o arquivo — Faz uma cópia do `.exe` do jogo e cola na raiz do Steamless — Executa o `Steamless.exe` com PortProton, seleciona o atalho e gera a versão sem DRM — Substitui essa versão no local do jogo e renomeia conforme necessário

> [!WARNING]
> Steamless remove DRM, SteamStub e variantes. Portanto, Denuvo, entre outros, não irão funcionar.

- [Tutorial em vídeo](https://www.youtube.com/watch?v=fOxr_FuCRdA)
- [PortProton](https://flathub.org/pt-BR/apps/ru.linux_gaming.PortProton)
- [Atalhos corrigidos](/scripts/Steamless/fix/)

### Jogos que dependem de launcher

Baixar o fix e substituir os arquivos do jogo

- [Tutorial em vídeo](https://www.youtube.com/watch?v=a2dd0BnXN4s)
- [Fixes - Ryuu](https://generator.ryuu.lol/fixes)

## Créditos

<p style="display: flex; align-items: center; gap: 8px;">
  <img src="assets/credits.svg" alt="Credits Icon" width="20" height="20" />
  <span>Meus sinceros agradecimentos a estes incríveis projetos: </span>
  <img src="assets/credits.svg" alt="Credits Icon" width="20" height="20" />
</p>

- [SLSsteam](https://github.com/AceSLS/SLSsteam)
- [DepotDownloaderMod](https://github.com/SteamAutoCracks/DepotDownloaderMod)
- [Conheci o Accela neste canal](https://www.youtube.com/watch?v=jQUEtr200SU)
- [SLScheevo](https://github.com/xamionex/SLScheevo)
- [SLSah](https://github.com/niwia/SLSah)
- [Steamless](https://github.com/atom0s/Steamless)
- [ludusavi](https://github.com/mtkennerly/ludusavi)
