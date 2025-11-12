## 1. SLSsteam

**Fonte:** ([GitHub - AceSLS/SLSsteam](https://github.com/AceSLS/SLSsteam)), [Reddit - GUIA](https://www.reddit.com/r/SteamDeckPirates/comments/1leqim0/guide_slssteam_how_to_unlock_dlcs_bypass_family/?tl=pt-br)

## 2. ACCELA

**Fonte:** [Youtube - JD Ros](https://www.youtube.com/watch?v=jQUEtr200SU)

> [!WARNING]
> 
> Não encontrei o responsável direto por essa ferramenta. No entanto, ao analisar o arquivo `main.py` disponível, é possível observar que ela utiliza o projeto [SteamDepotDownloaderGUI](https://github.com/mmvanheusden/SteamDepotDownloaderGUI?tab=readme-ov-file) como base.

### Diferenças entre o instalador original e a versão modificada

| Aspecto              | Original           | Modificado                                           |
| -------------------- | ------------------ | ---------------------------------------------------- |
| Propósito            | Instala o ACCELA ✅ | Instala o ACCELA ✅                                   |
| Funcionalidade extra | Nenhuma ❌          | Verifica dependências e limpa instalações antigas. ✅ |

## 3. SLSah

**Fonte:** [GitHub - niwia/SLSah](https://github.com/niwia/SLSah) 

### Diferenças entre o instalador original e a versão modificada

| Aspecto              | Original          | Modificado                                                                   |
| -------------------- | ----------------- | ---------------------------------------------------------------------------- |
| Propósito            | Instala o SLSah ✅ | Instala o SLSah ✅                                                            |
| Funcionalidade extra | Nenhuma ❌         | Verifica dependências, detecta o terminal correto e cria atalho universal. ✅ |

## 4. SLScheevo

**Fonte:** [Github - xamionex/SLScheevo](https://github.com/xamionex/SLScheevo)

> [!TIP]
> 
> SLSah e SLScheevo são ferramentas responsáveis por gerar conquistas. As principais diferenças entre elas são que a segunda opção funciona sem erros em idiomas diferentes do inglês e tem meios de autenticação distintos. Fiz um vídeo mostrando o bug ao tentar gerar conquistas em pt-br com a primeira opção: [SLSah vs SLScheevo](https://www.youtube.com/watch?v=_X0CgRynwLQ).

## Instalação SLStools ⚒

```bash
curl -sSL https://raw.githubusercontent.com/aglairdev/SLStools/main/install.sh | bash
```

- [Tutorial em vídeo](https://www.youtube.com/watch?v=L3NCe-Yk0vs)

## Config

### SLSsteam

`~/.config/SLSsteam/config.yaml`

PlayNotOwnedGames: yes

### Accela

<p align="center">
  <img src="accela-config.png" width="400"/>
  <img src="accela-config-2.png" width="400"/>
</p>

### Driver recomendado (Nvidia)

- nvidia-driver-570

### Manifests

- [generator.ryuu.lol](https://generator.ryuu.lol/)

## Backup de saves/conquistas

```bash
cd ~/SLStools
sudo chmod +x backup.sh
./backup.sh
```

## Desinstalação

```bash
cd ~/SLStools
sudo chmod +x uninstall.sh
./uninstall.sh
```

## Demo

![demo](demo.gif)

## Fix

### Jogos com launcher

- [Fixes](https://generator.ryuu.lol/fixes)
- [Tutorial em vídeo](https://www.youtube.com/watch?v=a2dd0BnXN4s)

### Application load error 6:0000065432

- [PortProton](https://flathub.org/pt-BR/apps/ru.linux_gaming.PortProton)
- [Steamless](https://github.com/atom0s/Steamless)
- [Tutorial em vídeo](https://www.youtube.com/watch?v=fOxr_FuCRdA)
