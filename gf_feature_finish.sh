#!/bin/zsh

# ----------------------------------------------
# Script: gf_feature_finish.sh
# Funzioni:
#   1. Identifica il branch corrente
#   2. Verifica che sia una feature
#   3. Esegue git flow finish
#   4. Esegue push su remoto
#   5. Crea PR verso develop
# ----------------------------------------------

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ "$CURRENT_BRANCH" != feature/* ]]; then
    echo "❌ Devi essere su un branch feature/* per usare questo script."
    exit 1
fi

FEATURE_NAME=${CURRENT_BRANCH#feature/}

echo "🔚 Sto chiudendo la feature: $FEATURE_NAME"

git flow feature finish "$FEATURE_NAME"

if [ $? -ne 0 ]; then
    echo "❌ Errore durante il git flow finish."
    exit 1
fi

echo "⬆️ Push del branch develop su remoto..."
git push origin develop

echo "🧹 Push dei rami eliminati..."
git push --all
git push --tags

echo "🔀 Creazione Pull Request su GitHub..."

gh pr create \
    --base develop \
    --head "feature/$FEATURE_NAME" \
    --title "Feature: $FEATURE_NAME" \
    --body "PR automatica generata dal workflow"

if [ $? -eq 0 ]; then
    echo "✅ Pull Request creata con successo!"
else
    echo "❌ Errore nella creazione della Pull Request."
fi
