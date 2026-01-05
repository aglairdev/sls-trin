[![Branch](https://img.shields.io/badge/Branch%20-Accela-f070D0.svg?longCache=true&style=for-the-badge)](https://github.com/aglairdev/SLStools/tree/accela)

> [!WARNING]
> **Este fork não acompanha a versão atual do Accela**
> 
> A atual versão do Accela `2026.01.01-15_42_36` abrange personalização, instalação do SLSsteam, remoção eficaz de DRM através do Steamless, geração de conquistas com SLScheevo, remoção de jogos, adição de jogos via API Morrenus entre outros
>
> O instalador [enter-the-wired](https://github.com/ciscosweater/enter-the-wired) instala todas dependências necessárias para funcionamento e a última versão do Accela
>
> Recomendo as seguintes fontes para manter-se atualizado: [Ciskao - Youtube](https://www.youtube.com/@ciskao) | [Ciskao - Discord](https://discord.gg/J9UApb8q) e [JD ROS - Youtube](https://www.youtube.com/@JDRos)
>
> Fiz um [vídeo-tutorial](https://www.youtube.com/watch?v=JO1L282VJV0) usando `enter-the-wired`, [Millennium](https://github.com/SteamClientHomebrew/Millennium), [Cyberia](https://github.com/ciscosweater/cyberia) e `Morrenus-API`

## Atualizações

- Integração com o SLScheevo
- Modificação da interface do Accela para se adaptar ao SLStools
- Tradução da interface para pt-BR 🇧🇷
- Configuração padrão de `PlayNotOwnedGames: yes`
- Atalho no desktop configurado com a variável de ambiente do SLSsteam, evitando erros de inicialização causados por atalhos incorretos
- Integração com "online-fix"
- Integração com a busca de Manifests via API Morrenus, inspirada na versão Accela 2.5.1. [Drive](https://gofile.io/d/bzrPXa)
- Integração com a busca de Manifests direta, inspirada no Bifrost. [Drive](https://drive.google.com/file/d/1ltDw42-KjkSs1zvXwDtH9BwZJeXKQUYB/view), [Geovany G - Youtube](https://www.youtube.com/@vdmplays)

## Requisitos

- `curl`
- Steam nativa (**não** compatível com Flatpak ou Snap)

## Distros testadas

| Distro   | Status |
|----------|:-------: |
| Kubuntu  |   ✅     |
| Zorin    |   ✅     |
| Mint     |   ✅     |
| Cachy    |   ✅     |
| Manjaro  |   ✅     |
| Arch     |   ✅     |

## Instalação

```bash
curl -sSL https://raw.githubusercontent.com/aglairdev/SLStools/main/install.sh | bash
```

<p align="center">
  <img src="assets/demo.gif" width="500"/>
</p>

## Config

### Depots

- [Ryuu](https://generator.ryuu.lol/)
- [Luatools](https://discord.com/invite/luatools)
> luatools — gen-games-here — [appid]

Linux:
- O executável e o launcher (se houver) precisam de permissão de execução manual

Windows:
- Ative o Proton (recomenda-se a versão experimental)

### SLScheevo

Abra o SLScheevo pelo menos uma vez para adicionar as credenciais

### Online-fix

Ative ou desative o checkbox "Ativar online-fix"

### Morrenus API

- [Discord](https://manifest.morrenus.xyz/auth/discord)
- [Site](https://manifest.morrenus.xyz/)

> Entre primeiro no server do Discord e apenas depois gere a chave API

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
> Steamless remove DRM, SteamStub e variantes. Portanto, Denuvo, entre outros, não irão funcionar

- [Tutorial em vídeo](https://www.youtube.com/watch?v=fOxr_FuCRdA)
- [PortProton](https://flathub.org/pt-BR/apps/ru.linux_gaming.PortProton)
- [Atalhos corrigidos](https://github.com/aglairdev/SLStools/tree/fix)

### Jogos que dependem de launcher

Baixar o fix e substituir os arquivos do jogo

- [Fixes - Ryuu](https://generator.ryuu.lol/fixes)

## Créditos

- [SLSsteam](https://github.com/AceSLS/SLSsteam)
- [DepotDownloaderMod](https://github.com/SteamAutoCracks/DepotDownloaderMod)
- Accela: *Autores desconhecidos.* Fontes confiáveis: [Ciskao - Youtube](https://www.youtube.com/@ciskao) | [Ciskao - Discord](https://discord.gg/g5rzCecj) e [JD Ros - Youtube](https://www.youtube.com/@JDRos)
- [SLScheevo](https://github.com/xamionex/SLScheevo)
- [SLSah](https://github.com/niwia/SLSah)
- [Steamless](https://github.com/atom0s/Steamless)
- [ludusavi](https://github.com/mtkennerly/ludusavi)
- [Morrenus API](https://manifest.morrenus.xyz/)
