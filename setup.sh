#!/bin/bash
# Winterdienst Backend Setup
# Solano Beschattungsmontagen OG

echo "=== Winterdienst Setup ==="
echo ""

# Ins Backend Verzeichnis
cd "$(dirname "$0")/backend"

# Datenbank einrichten
echo "1. Datenbank einrichten..."
psql postgres -f db_setup.sql
echo ""

# NPM Pakete installieren
echo "2. Node.js Pakete installieren..."
npm install
echo ""

echo "=== Setup abgeschlossen! ==="
echo ""
echo "Backend starten mit:"
echo "  cd backend && npm start"
echo ""
echo "Oder für Entwicklung mit Auto-Reload:"
echo "  cd backend && npm run dev"
