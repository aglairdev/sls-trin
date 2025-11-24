## Updates

Integração com SLScheevo e modificação da interface do Accela para SLStools.

## Instalação

```bash
curl -sSL https://raw.githubusercontent.com/aglairdev/SLStools/conquistas/install.sh | bash
```
> [!WARNING]
> **Inicie a compra com a Steam fechada**. O script abre a Steam para reconhecer o jogo pelo SLScheevo e, após gerar as conquistas, solicita a reinicialização da Steam. Se a Steam estiver aberta, o script pode não conseguir reconhecer o jogo corretamente e falhar na geração das conquistas.

## Config

### SLSscheevo

Abra o SLScheevo pelo menos uma vez para adicionar as credenciais.

<p align="center">
  <img src="assets/config.png" width="400"/>
</p>

### SLSsteam

> Botão de "Jogar" com status "COMPRAR".

Após comprar um jogo, um documento de configuração é gerado. Modifique um parâmetro neste arquivo.

`~/.config/SLSsteam/config.yaml`

PlayNotOwnedGames: yes
