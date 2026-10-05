# ReceptaMed — aplicativos de teste, 05/10/2026

## Entrega
- APK Android assinado para instalação direta, Android 8 ou posterior.
- Projeto iOS para iPhone/iPad (iOS 16+). Não foi compilado neste ambiente Linux. Não há IPA assinado nesta entrega.
- Estes aplicativos são clientes nativos que abrem o sistema web publicado, com a mesma conta e dados reais. Não são uma reimplementação offline da agenda. Use dados fictícios na homologação.
- Ainda não houve teste em aparelho físico nem publicação nas lojas. O fato de compilar não garante aprovação na App Store/Google Play.

## Instalar Android
1. Transfira ReceptaMed-Android-Teste.apk para o aparelho.
2. Abra o arquivo e, se o Android solicitar, permita a instalação por esse navegador/gerenciador de arquivos.
3. Instale ReceptaMed Teste e faça login. Use uma clínica de teste.
4. Desative novamente a permissão de instalar aplicativos desconhecidos após instalar.

É uma assinatura de teste, não a chave definitiva de distribuição. Uma futura versão assinada com outra chave pode exigir desinstalar o app de teste; os dados permanecem no servidor. Não desative o Play Protect.

## Limitações desta versão
- Internet obrigatória; não há sincronização offline.
- Não inclui push nativo nem integração nativa com WhatsApp.
- Exportação de Excel/PDF e impressão devem ser realizadas pelo site aberto no Chrome ou, para downloads reconhecidos, pela opção Abrir navegador no aviso de exportação; arquivos blob e janelas de impressão precisam de implementação/testes nativos adicionais.
- Pagamentos podem abrir o navegador externo e exigir login separado. A cobrança real do sistema web ainda está em configuração; este APK não a ativa.
- Confirmações de e-mail e redefinição de senha continuam no navegador, depois faça login no aplicativo.
- O ícone e nome incluem identificação de teste. A publicação comercial exige assinatura definitiva, revisão do produto e das políticas das lojas, especialmente pagamentos e dados de saúde.

## iPhone sem possuir Mac: Codemagic
1. Use uma conta pessoal em https://codemagic.io e um repositório privado no GitHub/GitLab/Bitbucket.
2. Envie o conteúdo desta pasta para a raiz do repositório; não envie segredos nem dados de pacientes.
3. Conecte o repositório ao Codemagic e selecione codemagic.yaml.
4. Execute manualmente ios-compile-check para validar no Mac da nuvem. O resultado de simulador NÃO instala em iPhone.
5. Para TestFlight/App Store, inscreva-se no Apple Developer Program e cadastre o identificador br.com.receptasistemas.receptamed.preview (ou substitua consistentemente pelo definitivo).
6. No Codemagic, configure Code signing identities com certificado Apple Distribution e perfil App Store para o identificador. Eles podem ser gerados com a integração App Store Connect, conforme a documentação oficial. Guarde chaves exclusivamente no cofre de segredos.
7. Cadastre o aplicativo no App Store Connect com o mesmo identificador. Execute ios-signed-ipa. Depois configure a integração de publicação no Codemagic para enviar o IPA ao TestFlight. O workflow entregue não publica automaticamente.
8. Teste login, convite, recuperação de senha, navegação, teclado, orientação, sessão e cobrança. Só distribua comercialmente após validação e revisão da Apple.

A conta pessoal Codemagic anuncia 500 minutos mensais gratuitos de Mac M2; confirme a oferta e mantenha cobrança excedente desativada. Apple Developer anuncia US$99/ano (moeda local quando disponível). Nenhuma conta paga foi criada e nenhuma cobrança foi autorizada por esta entrega.

Referências: https://docs.codemagic.io/billing/pricing/ ; https://docs.codemagic.io/yaml-quick-start/building-a-native-ios-app/ ; https://docs.codemagic.io/yaml-code-signing/signing-ios/ ; https://developer.apple.com/programs/enroll/

## Compilar Android novamente
Abra android/ no Android Studio, instale Android SDK 35, use JDK 17 e Gradle 8.9 com Android Gradle Plugin 8.7.3. Gere APK em Build > Generate App Bundles or APKs. Para produção, defina uma chave própria e guarde cópia segura. A chave temporária usada nesta entrega não acompanha o projeto.

## Segurança dos clientes
HTTPS obrigatório; certificado TLS inválido é recusado; não há exceção de ATS no iOS. Navegação interna limitada ao domínio publicado; links externos usam navegador. Nenhuma chave de API está embutida. Android não exporta ponte JavaScript, não permite arquivos locais nem tráfego HTTP e desativa backup do aplicativo.

## Android 1.0.1 — interface sem barra de navegador
Removidos Voltar, Atualizar, Navegador e a barra de progresso superior. Use o gesto/botão Voltar do Android. Uma falha de conexão apresenta opção de tentar novamente apenas no erro. Mantidas as barras do próprio Android e a proteção contra certificados inválidos. O APK continua sendo um aplicativo híbrido com WebView: esta mudança não o converte em telas nativas. Mesma identidade e assinatura de teste, versionCode 2, permitindo atualizar a versão anterior. Compilação e assinatura verificadas; validação visual desta atualização em aparelho ainda pendente.

Android 1.0.2: recompilação limpa, versionCode 3, mesma assinatura, APK ReceptaMed-Android-1.0.2.apk. Verificado no DEX: nenhum android.widget.Button e nenhum texto Atualizar. Validação em aparelho pendente.

Android 1.0.3: versionCode 4, mesma assinatura de teste, sem toolbar. Carrega o site publicado com correção do menu (v91).

Android 1.0.4: build 5, mesma assinatura de teste; usa site v92 com manual autenticado. iOS: projeto preparado parcialmente, ver app-store/PUBLICACAO.txt. Não existe IPA compilado/assinado nesta entrega.
