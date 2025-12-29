#!/bin/bash

# Konfigurasi
BASE_DIR="$HOME/project"
mkdir -p "$BASE_DIR"

# Warna untuk UI
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

header() {
    clear
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${GREEN}    PODMAN PROJECT MANAGER (PMAN)      ${NC}"
    echo -e "${BLUE}=======================================${NC}"
}

create_project() {
    header
    echo -e "${YELLOW}--- Membuat Project Baru ---${NC}"
    read -p "Nama Project: " NAME
    
    if [ -d "$BASE_DIR/$NAME" ] || podman pod exists "$NAME"; then
        echo -e "${RED}Error: Project atau Pod dengan nama tersebut sudah ada!${NC}"
        read -p "Tekan Enter untuk kembali..."
        return
    fi

    echo -e "\nTipe Project:\n1) WordPress\n2) Laravel"
    read -p "Pilihan: " TYPE
    echo -e "\nDatabase:\n1) MariaDB\n2) MySQL"
    read -p "Pilihan: " DB
    echo -e "\nWeb Server:\n1) Apache\n2) Nginx"
    read -p "Pilihan: " WEB
    read -p "Port (contoh 8080): " PORT

    PROJ_DIR="$BASE_DIR/$NAME"
    mkdir -p "$PROJ_DIR"/{db_data,app_data}

    podman pod create --name "$NAME" -p "$PORT:80"

    DB_IMG="mariadb:latest"
    [ "$DB" == "2" ] && DB_IMG="mysql:latest"
    
    echo -e "${BLUE}>> Menjalankan Database ($DB_IMG)...${NC}"
    podman run -d --pod "$NAME" --name "${NAME}_db" \
        -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=app_db \
        -v "$PROJ_DIR/db_data:/var/lib/mysql:Z" "$DB_IMG"

    echo -e "${BLUE}>> Melakukan Auto-Scaffolding...${NC}"
    
    if [ "$TYPE" == "1" ]; then
        podman run --rm -v "$PROJ_DIR/app_data:/data:Z" \
            docker.io/library/wordpress:cli-php8.2 \
            wp core download --path=/data
        
        APP_IMG="wordpress:latest"
        [ "$WEB" == "2" ] && APP_IMG="wordpress:php8.2-fpm"
        
        podman run -d --pod "$NAME" --name "${NAME}_app" \
            -e WORDPRESS_DB_HOST=127.0.0.1 -e WORDPRESS_DB_USER=root \
            -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=app_db \
            -v "$PROJ_DIR/app_data:/var/www/html:Z" "$APP_IMG"
            
    else
        podman run --rm -v "$PROJ_DIR/app_data:/app:Z" \
            docker.io/library/composer:latest \
            composer create-project laravel/laravel /app
            
        APP_IMG="php:8.2-apache"
        [ "$WEB" == "2" ] && APP_IMG="php:8.2-fpm"

        podman run -d --pod "$NAME" --name "${NAME}_app" \
            -v "$PROJ_DIR/app_data:/var/www/html:Z" "$APP_IMG"
    fi

    echo -e "${GREEN}Project $NAME berhasil dibuat!${NC}"
    echo -e "Akses di: http://localhost:$PORT"
    read -p "Tekan Enter untuk melanjutkan..."
}

manage_projects() {
    ACTION=$1
    header
    echo -e "${YELLOW}--- $ACTION Project ---${NC}"
    mapfile -t PODS < <(podman pod ps --format "{{.Name}}" | grep -v "NAME")
    
    if [ ${#PODS[@]} -eq 0 ]; then
        echo "Tidak ada project aktif."
        read -p "Tekan Enter..."
        return
    fi

    for i in "${!PODS[@]}"; do
        echo "$((i+1)). ${PODS[$i]}"
    done
    echo "0. Kembali"

    read -p "Pilih nomor: " NUM
    [ "$NUM" == "0" ] || [ -z "$NUM" ] && return
    SEL_POD=${PODS[$((NUM-1))]}

    case $ACTION in
        "START") podman pod start "$SEL_POD" ;;
        "STOP")  podman pod stop "$SEL_POD" ;;
        "DELETE")
            read -p "Yakin hapus $SEL_POD dan semua datanya? (y/n): " CONFIRM
            if [ "$CONFIRM" == "y" ]; then
                echo -e "${RED}>> Menghapus Project $SEL_POD...${NC}"
                podman pod stop "$SEL_POD" &>/dev/null
                podman pod rm -f "$SEL_POD"
                rm -rf "$BASE_DIR/$SEL_POD"
                echo -e "${GREEN}Project berhasil dihapus total.${NC}"
            fi
            ;;
    esac
    read -p "Selesai. Tekan Enter..."
}

# Loop Utama
while true; do
    header
    echo -e "1. Buat Project Baru"
    echo -e "2. Jalankan (Start) Project"
    echo -e "3. Hentikan (Stop) Project"
    echo -e "4. Hapus (Delete) Project"
    echo -e "5. Lihat Semua Project"
    echo -e "6. Keluar"
    read -p "> " OPT
    case $OPT in
        1) create_project ;;
        2) manage_projects "START" ;;
        3) manage_projects "STOP" ;;
        4) manage_projects "DELETE" ;;
        5) header; podman pod ps; read -p "Enter...";;
        6) exit 0 ;;
    esac
done