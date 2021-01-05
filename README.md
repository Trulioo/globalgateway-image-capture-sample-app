# GlobalGateway Image Capture Sample App

### Linux Prerequisites
Node Js  
NPM  
Git  

### Linux instructions (Ubuntu)
1. Obtain a token from support@trulioo.com
1. Clone the GlobalGateway Image Capture repo  
   sudo git clone https://github.com/Trulioo/globalgateway-image-capture-sample-app.git
1. Navigate to the installation package “cd globalgateway-image-capture-sample-app/”
1. Open the .npmrc file with your favorite text editor “sudo nano .npmrc”
1. Replace IMAGECAPTURE_SDK_NPM_AUTH_TOKEN with the token you've received from the Customer Success team
1. To install the package, run the command “sudo npm ci”
1. To update version of the SDK to the latest package, run the command “sudo npm run update-gg-capture”
1. To launch the sample app, run the command “sudo HTTPS=true npm start"
1. Launch your browser and the application on the IP where Node has been launched with the sample app

Detailed installation steps available at:  
https://developer.trulioo.com/docs/globalgateway-image-capture-sdk-sample-app-installation-guide  

For more information on how to use the SDK, see:  
https://developer.trulioo.com/docs/trulioo-image-capture
