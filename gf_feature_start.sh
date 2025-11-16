#!/bin/zsh

echo "🔧 Nome della feature da creare:"
read FEATURE_NAME

if [ -z "$FEATURE_NAME" ]; then
    echo "❌ Nome non valido."
    exit 1
fi

echo "🚀 Avvio feature: $FEATURE_NAME"
git flow feature start "$FEATURE_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Feature $FEATURE_NAME creata con successo."
else
    echo "❌ Errore nella creazione della feature."
fi
