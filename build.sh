#!/usr/bin/env bash
set -euo pipefail

# build.sh: Compila el repositorio gperftools en un binario ejecutable.
# Este script asume que el repositorio fue clonado y contiene el Makefile.

BUILD_CMD="make"
TARGET="luxor_engine"

echo "[Build] Iniciando compilación de gperftools..."

if ! command -v "$BUILD_CMD" >/dev/null 2>&1; then
  echo "[Error] 'make' no está disponible en el sistema. Instala make e inténtalo de nuevo."
  exit 1
fi

if [ ! -f Makefile ]; then
  echo "[Error] No se encontró Makefile en el directorio actual. Asegúrate de ejecutar este script desde la raíz del repositorio."
  exit 1
fi

CPU_JOBS=1
if command -v nproc >/dev/null 2>&1; then
  CPU_JOBS=$(nproc)
fi

echo "[Build] Limpiando el directorio de compilación..."
$BUILD_CMD clean || true

echo "[Build] Ejecutando: $BUILD_CMD -j$CPU_JOBS"
$BUILD_CMD -j"$CPU_JOBS"

if [ -f "$TARGET" ]; then
  echo "[Success] Compilación terminada: $TARGET"
  exit 0
else
  echo "[Error] La compilación no produjo el ejecutable $TARGET. Revisa los mensajes anteriores."
  exit 1
fi