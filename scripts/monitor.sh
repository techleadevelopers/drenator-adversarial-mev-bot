#!/bin/bash

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}📊 MONITORAMENTO - SNIPER APT${NC}"
echo -e "${YELLOW}========================================${NC}"

# Solicita dados
read -p "📌 IP da VPS: " VPS_IP
read -p "🔑 Usuário (padrão: root): " VPS_USER
VPS_USER=${VPS_USER:-root}
read -s -p "🔒 Senha: " VPS_PASS
echo ""

# Menu de opções
echo -e "\n${GREEN}Opções disponíveis:${NC}"
echo "1) Ver logs do sniper"
echo "2) Ver status do processo"
echo "3) Anexar ao screen (monitorar ao vivo)"
echo "4) Ver uso de recursos (CPU/RAM)"
echo "5) Sair"

read -p "Escolha uma opção: " OPTION

case $OPTION in
    1)
        echo -e "${YELLOW}📋 Últimas 50 linhas do log:${NC}"
        sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "cd /opt/sniper && tail -50 backdoor_instaladas.log 2>/dev/null || echo 'Log não encontrado'"
        ;;
    2)
        echo -e "${YELLOW}🔍 Processos do sniper:${NC}"
        sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "ps aux | grep sniper | grep -v grep"
        ;;
    3)
        echo -e "${YELLOW}🖥️  Anexando ao screen... (Ctrl+A+D para desanexar)${NC}"
        sshpass -p "$VPS_PASS" ssh -t -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "cd /opt/sniper && screen -r sniper"
        ;;
    4)
        echo -e "${YELLOW}📊 Uso de recursos:${NC}"
        sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP "htop -C -d 10"
        ;;
    5)
        echo -e "${RED}Saindo...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Opção inválida!${NC}"
        ;;
esac