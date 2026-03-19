#!/bin/bash

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}🛠️  CONFIGURANDO VPS - SNIPER APT${NC}"
echo -e "${YELLOW}========================================${NC}"

# Solicita dados
read -p "📌 IP da VPS: " VPS_IP
read -p "🔑 Usuário (padrão: root): " VPS_USER
VPS_USER=${VPS_USER:-root}
read -s -p "🔒 Senha: " VPS_PASS
echo ""

# Comandos para executar na VPS
COMMANDS=(
    "apt-get update"
    "apt-get install -y screen htop nload"
    "mkdir -p /opt/sniper"
    "echo '📁 Pasta /opt/sniper criada'"
    "ufw allow out 22/tcp"
    "ufw allow out 56/tcp"
    "ufw allow out 443/tcp"
    "ufw --force enable"
    "echo '🔥 Firewall configurado'"
    "echo '✅ VPS pronta para receber o sniper'"
)

# Executa comandos via SSH
for CMD in "${COMMANDS[@]}"; do
    echo -e "${YELLOW}▶ Executando: $CMD${NC}"
    sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "$CMD"
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ VPS CONFIGURADA!${NC}"
echo -e "${GREEN}📌 Agora execute: ./scripts/deploy-to-vps.sh${NC}"
echo -e "${GREEN}========================================${NC}"