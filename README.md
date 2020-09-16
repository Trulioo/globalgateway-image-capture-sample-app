# GlobalGateway Image Capture Sample App

### Release Notes
GlobalGateway Web SDK **v1.0.23** provides the following additional benefits to the customers:


* Accessibility support - resizing of the text and support for iOS (Voice Over), android (Voice Assistant) and 3rd party (JAWS and NVDA) desktop Screen Readers
* For passport auto-capture, a new hint message “Passport not detected” is added when a non-passport document is scanned by a person or MRZ is obstructed
* Size of the guide window for documents and selfies have been increased to capture a larger image, resulting in fewer face comparison and liveness errors across global identity documents especially GBR, NLD, and ITA
* Removed the dependency on JQuery when embedding the SDK as a video element 
* User behaviour information available in API response
    * TimeStamp information from the document capture
    * Retry count can be added during document capture 
    * Liveness confirmation, if the user performed selfie using auto capture functionality


### Windows Prerequisites
Git Bash for Windows https://git-scm.com/downloads  
Node Js for Windows https://nodejs.org/en/download/  

*If you installed Node before Git Bash you may need to restart the Git Bash application

### Windows instructions
1. Download the sample app from GitHub and unzip the package to your desired location  
   Download URL: https://github.com/Trulioo/globalgateway-image-capture-sample-app  
   or use Git clone  
   $ Git clone https://github.com/Trulioo/globalgateway-image-capture-sample-app
1. Obtain a token from support@trulioo.com 
1. Open the .npmrc file with your favorite text editor
1. Replace IMAGECAPTURE_SDK_NPM_AUTH_TOKEN with the token you've received from the Customer Success team
1. Launch Git Bash using administrative rights
1. Using Git Bash, navigate to the installation package where you unzipped the files in Step 1
1. To install the package, run the command “npm install”
1. To update to the latest version of the SDK, run the command "npm run update-gg-capture"
1. To launch the sample app, run the command “npm start”
1. Launch your browser and the application on the IP where Node has been launched with the sample app

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
1. To install the package, run the command “sudo npm install”
1. To update version of the SDK to the latest package, run the command “sudo npm run update-gg-capture”
1. To launch the sample app, run the command “sudo HTTPS=true npm start"
1. Launch your browser and the application on the IP where Node has been launched with the sample app

Detailed installation steps available at:  
https://developer.trulioo.com/docs/globalgateway-image-capture-sdk-sample-app-installation-guide  

For more information on how to use the SDK, see:  
https://developer.trulioo.com/docs/trulioo-image-capture
