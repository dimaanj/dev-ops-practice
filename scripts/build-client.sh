cd ../../shop-angular-cloudfront

echo "Installing deps..."
npm install

echo "Building..."
set ENV_CONFIGURATION=production
npm run build --configuration=$ENV_CONFIGURATION

echo "Compressing app..."
rm -f dist/client-app.zip
zip -r dist/client-app.zip dist