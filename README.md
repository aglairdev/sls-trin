[![Branch: SLStools integrado com conquistas](https://img.shields.io/badge/Branch-SLStools%20integrado%20com%20conquistas%20-blue)](https://github.com/aglairdev/SLStools/tree/conquistas)


## Updates

- O Accela foi otimizado com maior compatibilidade, instalação limpa e verificação automática de dependências.
- O SLSah foi atualizado com verificação de dependências, detecção automática de terminal, atualização do repositório e atalho universal na área de trabalho.

## Requisitos

- `curl`
- Steam nativa (não compatível com Flatpak ou Snap)

## Distros testadas

| Distro   | Status |
|----------|:-------: |
| Kubuntu  |   ✅     |
| Zorin    |   ✅     |
| Manjaro  |   ✅     |

## Instalação

```bash
curl -sSL https://raw.githubusercontent.com/aglairdev/SLStools/main/install.sh | bash
```

- [Tutorial com SLScheevo](https://www.youtube.com/watch?v=L3NCe-Yk0vs)
- [Tutorial com SLSah](https://www.youtube.com/watch?v=MH8kYaEtA6U)

## Config

### Depots

- [Ryuu](https://generator.ryuu.lol/)
- [Luatools](https://discord.com/invite/luatools)
> luatools — gen-games-here — [appid]

### Accela

Ative a opção `SLSsteam Wrapper Mode`

<p align="center">
  <img src="assets/accela-config.png" width="400"/>
</p>

### Conquistas

#### SLScheevo

```bash
cd ~/SLStools/conquistas/SLScheevo
./run.sh
```
> A ferramenta solicita credenciais da Steam.

#### SLSah

```bash
cd ~/SLStools/conquistas/
./SLSah-M.sh
```

> A ferramenta solicita uma chave API e ID da Steam.

### Driver recomendado (Nvidia)

- nvidia-driver-570

## Backup saves/conquistas

```bash
cd ~/SLStools/scripts/
sudo chmod +x backup.sh
./backup.sh
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

<p align="center">
  <img src="assets/fix-disponivel-para.png" width="200"/>
</p>

Botão direito no jogo — Propriedades — Compatibilidade — Forçar uso de ferramenta de compatibilidade do Steam Play específica — Proton Experimental

<p align="center">
  <img src="assets/fix-6_0000065432.png" width="200"/>
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

- [SLSsteam](https://github.com/AceSLS/SLSsteam)
- [DepotDownloaderMod](https://github.com/SteamAutoCracks/DepotDownloaderMod)
- [Conheci o Accela neste canal, mas seu real autor é desconhecido](https://www.youtube.com/watch?v=jQUEtr200SU)
- [SLScheevo](https://github.com/xamionex/SLScheevo)
- [SLSah](https://github.com/niwia/SLSah)
- [Steamless](https://github.com/atom0s/Steamless)