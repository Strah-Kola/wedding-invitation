#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SITE_DIR="${SCRIPT_DIR}/site"

required_files=(
  "index.html"
  "styles.css"
  "script.js"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "${ROOT_DIR}/${file}" ]]; then
    echo "ERROR: required file not found: ${ROOT_DIR}/${file}" >&2
    exit 1
  fi
done

if [[ ! -d "${ROOT_DIR}/assets" ]]; then
  echo "ERROR: assets directory not found: ${ROOT_DIR}/assets" >&2
  exit 1
fi

rm -rf "${SITE_DIR}"
mkdir -p "${SITE_DIR}"

cp "${ROOT_DIR}/index.html" "${SITE_DIR}/"
cp "${ROOT_DIR}/styles.css" "${SITE_DIR}/"
cp "${ROOT_DIR}/script.js" "${SITE_DIR}/"

if [[ -f "${ROOT_DIR}/robots.txt" ]]; then
  cp "${ROOT_DIR}/robots.txt" "${SITE_DIR}/"
fi

cp -a "${ROOT_DIR}/assets" "${SITE_DIR}/assets"

find "${SITE_DIR}" -type d -exec chmod 755 {} +
find "${SITE_DIR}" -type f -exec chmod 644 {} +

echo
echo "Kola deployment package prepared:"
echo "${SITE_DIR}"
echo

du -sh "${SITE_DIR}"
