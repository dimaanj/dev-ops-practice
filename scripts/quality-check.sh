cd ../../shop-angular-cloudfront

#     "lint": "ng lint",
#     "test": "ng test",
#     "e2e": "ng e2e",

{
    echo "Starting linting check..."
    npm run lint
    echo "Starting linting check..."
    npm run test
    echo "Starting e2e check..."
    npm run e2e
} || { 
   echo "Quality check failed!"
}