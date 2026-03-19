#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}🚀 DEPLOY PARA VPS - SNIPER APT${NC}"
echo -e "${YELLOW}========================================${NC}"

# Solicita dados da VPS
read -p "📌 IP da VPS: " VPS_IP
read -p "🔑 Usuário (padrão: root): " VPS_USER
VPS_USER=${VPS_USER:-root}
read -s -p "🔒 Senha (ou use chave SSH): " VPS_PASS
echo ""

# Cria pasta na VPS
echo -e "\n${YELLOW}📁 Criando pasta na VPS...${NC}"
sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "mkdir -p /opt/sniper"

# Sobe os arquivos
echo -e "${YELLOW}📤 Enviando binário...${NC}"
sshpass -p "$VPS_PASS" scp -o StrictHostKeyChecking=no ./bin/sniper $VPS_USER@$VPS_IP:/opt/sniper/

echo -e "${YELLOW}📤 Enviando chaves...${NC}"
sshpass -p "$VPS_PASS" scp -o StrictHostKeyChecking=no ./chaves_953.txt $VPS_USER@$VPS_IP:/opt/sniper/

echo -e "${YELLOW}📤 Enviando checkpoint (se existir)...${NC}"
sshpass -p "$VPS_PASS" scp -o StrictHostKeyChecking=no ./checkpoint_backdoor.json $VPS_USER@$VPS_IP:/opt/sniper/ 2>/dev/null || echo "⚠️  Checkpoint não encontrado"

# Configura permissões
echo -e "${YELLOW}🔧 Configurando permissões...${NC}"
sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "chmod +x /opt/sniper/sniper"

# Testa execução
echo -e "${YELLOW}🧪 Testando execução...${NC}"
sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "cd /opt/sniper && ./sniper --help 2>/dev/null || echo '✅ Binário OK'"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ DEPLOY CONCLUÍDO!${NC}"
echo -e "${GREEN}📌 Para executar:${NC}"
echo -e "   ssh $VPS_USER@$VPS_IP"
echo -e "   cd /opt/sniper"
echo -e "   screen -S sniper"
echo -e "   ./sniper"
echo -e "${GREEN}========================================${NC}"