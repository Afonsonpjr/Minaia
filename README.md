# Minaia — servidor Minecraft Java (Fabric)

Configuração de referência: Minecraft Java **26.1.2**, Fabric, Windows, Java **25+**, até 10 jogadores e acesso privado via Cloudflare Tunnel + Access.

> **Importante:** o endereço `mc.inkit.casa` é PROVISÓRIO, ainda não foi vinculado a um domínio Cloudflare. A configuração da zona DNS, do Tunnel e do Cloudflare Access deve ser concluída pelo proprietário da conta. O repositório não contém credenciais, executáveis .jar nem os mundos dos jogadores.

## 1. Preparar o servidor

1. Instale **Java 25 ou superior** e execute `java -version` no Prompt.
2. Baixe o instalador universal Fabric: https://fabricmc.net/use/installer/
3. Salve como `servidor/fabric-installer.jar` e, dentro da pasta `servidor`, execute:
   ```bat
   java -jar fabric-installer.jar server -mcversion 26.1.2 -downloadMinecraft
   ```
4. Confira o JAR inicializável gerado. Se tiver outro nome, renomeie **o launcher Fabric** para `fabric-server-launch.jar` (não renomeie `server.jar`).
5. Coloque as versões para **26.1.2** dos mods desejados em `servidor/mods/`. Fabric API de referência: `fabric-api-0.155.3+26.1.2.jar`. Carpet mencionado no plano: `fabric-carpet-26.1+v260402.jar` (verifique o carregamento e os comandos; a compatibilidade exata deve ser testada).
6. Leia a EULA: https://aka.ms/MinecraftEULA. **Só se concordar**, altere `servidor/eula.txt` para `eula=true`. O repositório mantém `eula=false`.
7. Execute `servidor/start.bat`. Espere `Done`; adicione jogadores usando `whitelist add NomeDoJogador` no console.

## 2. Configurar Cloudflare Tunnel localmente

Instale `cloudflared` no PC do servidor: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/

No Prompt do servidor:
```bat
cloudflared tunnel login
cloudflared tunnel create minaia-minecraft
cloudflared tunnel list
cloudflared tunnel route dns minaia-minecraft mc.inkit.casa
```

Copie `servidor/cloudflared-config.example.yml` para `%USERPROFILE%\.cloudflared\config.yml` e substitua `SEU_USUARIO` e `SEU_TUNNEL_UUID` pelos valores reais. O arquivo JSON de credenciais que a ferramenta gerou deve **continuar somente no seu PC**.

Valide e execute:
```bat
cloudflared tunnel ingress validate
```
Depois abra `servidor/start-tunnel.bat` em outra janela.

No dashboard Cloudflare Zero Trust, cadastre uma **aplicação Access self-hosted** para `mc.inkit.casa`, defina uma política Allow que inclua **somente os e-mails autorizados**, e confirme que a aplicação está protegida. Sem a política Access corretamente configurada, o login do jogador pode falhar. Não publique o servidor antes de restringir o acesso.

## 3. Jogadores

Cada participante deve instalar `cloudflared` e executar `servidor/jogador-conectar.bat` no seu PC. A ferramenta abre um navegador para autenticação Cloudflare Access quando necessário e cria o encaminhamento TCP local.

No Minecraft Java 26.1.2, conectar ao servidor `localhost:25566` (porta local diferente da porta do servidor para evitar conflito se o mesmo PC hospeda e joga). Mantenha o .bat aberto durante a sessão.

### Verificações e solução de problemas

- Não conecta: confirme `Done`, o Tunnel conectado e a política Cloudflare Access; verifique `cloudflared tunnel ingress validate`.
- Falha de mod: retire temporariamente o JAR do Carpet, teste Fabric/API e consulte `servidor/logs/latest.log`.
- Minecraft diz "You are not whitelisted": execute `whitelist add NICK` no console.
- Porta local ocupada: feche o processo local na porta 25566 ou ajuste a porta no .bat e no endereço do Minecraft.
- Para encerrar com segurança, execute `stop` no console do Minecraft.

### Segurança

Nunca faça commit dos arquivos `cert.pem`, `*.json` de credenciais do Tunnel, `ops.json`, `whitelist.json`, da pasta `world` nem do conteúdo de `logs`. O `.gitignore` ajuda a evitar commits acidentais. O Tunnel não substitui o controle de usuários `online-mode=true` e a whitelist do Minecraft.

Documentação: https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/cloudflared-authentication/arbitrary-tcp/ e https://wiki.fabricmc.net/install
