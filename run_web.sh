#!/bin/bash
# Script para rodar o Flutter Web com configurações otimizadas para Chrome/Linux
# Usa --web-browser-flag para desabilitar problemas conhecidos do CanvasKit

echo "Iniciando Flutter Web com otimizações para Chrome/Linux..."
flutter run -d chrome --web-port=8080 "$@"
