#!/bin/bash
set -e

echo "📦 Cloning Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b 3.22.0
export PATH="$PATH:$(pwd)/flutter/bin"

echo "⚙️ Configuring Flutter..."
flutter config --enable-web
flutter --version

echo "📥 Getting dependencies..."
flutter pub get

echo "🏗️ Building for web..."
flutter build web --release --web-renderer canvaskit
