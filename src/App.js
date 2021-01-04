import React, { useState } from 'react';
import ImageField from './ImageField';
import Button from 'react-bootstrap/Button';
import Dropdown from 'react-select';
import './css/app.css';
import 'bootstrap/dist/css/bootstrap.min.css';

const GlobalGatewayCapture = require('@trulioo/globalgateway-image-capture-sdk');

const useCaptureButton = false; // Change this value if you'd like to use the button while capturing

// const GlobalGatewayHints = {
//   GLOBALGATEWAY_HEAD_OUTSIDE: 'Place Face in Oval',
//   GLOBALGATEWAY_HEAD_SKEWED: 'Look Straight Ahead',
//   GLOBALGATEWAY_AXIS_ANGLE: 'Hold Phone Upright',
//   GLOBALGATEWAY_HEAD_TOO_CLOSE: 'Move Farther Away',
//   GLOBALGATEWAY_HEAD_TOO_FAR: 'Get Closer',
//   GLOBALGATEWAY_STAY_STILL: 'Hold Still',
//   GLOBALGATEWAY_STOP_SMILING: 'Stop Smiling',
//   GLOBALGATEWAY_SMILE: 'Smile!',
//   GLOBALGATEWAY_READY_POSE: 'Hold it There',
//   GLOBALGATEWAY_NO_FACE_FOUND: 'No Face Detected',
//   GLOBALGATEWAY_ERROR_GLARE: 'Reduce Glare',
//   GLOBALGATEWAY_ERROR_FOUR_CORNER: 'Document Not Found',
// };

const captureTypeOption = [
  { value: 'DocumentFront', label: 'ID Document Front' },
  { value: 'DocumentBack', label: 'ID Document Back' },
  { value: 'Passport', label: 'Passport' },
  { value: 'LivePhoto', label: 'Live Photo' },
];

const captureMode = [
  { value: 'Auto', label: 'Auto' },
  { value: 'Manual', label: 'Manual' },
];

const geoMode = [
  { value: true, label: 'Enable Geolocation Collection' },
  { value: false, label: 'Disable Geolocation Collection' },
];

const startMessage = 'Starting GlobalGateway Capture';
const defaultTimeout = 15 * 1000;

function App() {
  const [error, setError] = useState('');
  const [isAuto, setIsAuto] = useState(true);
  const [shouldCollectGeo, setShouldCollectGeo] = useState(true);
  const [captureType, setCaptureType] = useState(captureTypeOption[0].value);

  const [imgResult, setImgResult] = useState(null);

  const onImgSuccess = (res) => {
    setImgResult(res);
  };

  const onError = (errArray) => {
    let errorMessage = '';
    if (errArray && errArray.length > 0) {
      // handle different error code here
      for (let i = 0; i < errArray.length; i += 1) {
        errorMessage += `Error Code ${errArray[i].code}: ${errArray[i].type} \n`;
      }
    } else {
      errorMessage = 'Capture timeout';
    }
    if(errorMessage !== '') {
      setError(errorMessage);
    }
  };

  const startCapture = () => {
    const useCaptureButtonWithAutoOnly = (isAuto) ? useCaptureButton : false; // Do not modify this
    setError('');
    setImgResult(null);
    switch(captureType) {
      case 'DocumentBack':
      case 'DocumentFront':
        GlobalGatewayCapture.StartDocumentCapture(startMessage, defaultTimeout, isAuto, onImgSuccess, onError, useCaptureButtonWithAutoOnly, 0, shouldCollectGeo);
        break;
      case 'Passport':
        GlobalGatewayCapture.StartPassportCapture(startMessage, defaultTimeout, isAuto, onImgSuccess, onError, useCaptureButtonWithAutoOnly, 0, shouldCollectGeo);
        break;
      case 'LivePhoto' :
        GlobalGatewayCapture.StartSelfieCapture(startMessage, defaultTimeout, isAuto, onImgSuccess, onError, useCaptureButtonWithAutoOnly, 0, shouldCollectGeo);
        break;
      default:
        break;
    }  
  };
 
  // Default hint messages can be found at the beginning of this file
  // Hint messages can be customized:
  // GlobalGatewayCapture.GlobalGatewayHints.GLOBALGATEWAY_ERROR_FOUR_CORNER = "Cannot Find Document";

  return (
    <div id="ui-container">
      <div id="main-container">
        <div>
          <img id="trulioo-content-container-img" src="/images/global-gateway-title.svg" alt="" />
        </div>

        <div className="text-box"> 
          <h3 className="trulioo-header-font">To start the image capture</h3>
          <p className="trulioo-body-font">1. Select the capture mode to either Auto or Manual.</p>
          <p className="trulioo-body-font">2. Select the Document Type and click Begin.</p>
        </div>
        
        <div>
          <Dropdown 
            className="captureModeSelection"
            defaultValue={captureMode[0]}
            options={captureMode}
            isSearchable={false}
            onChange={(selected) => {
              setIsAuto(selected.value === 'Auto');
            }}
          />
          <Dropdown 
            className="captureModeSelection"
            defaultValue={captureTypeOption[0]}
            options={captureTypeOption}
            isSearchable={false}
            onChange={(selected) => {
              setCaptureType(selected.value);
            }}
          />
          <Dropdown 
            className="GeoCollectionSelection"
            defaultValue={geoMode[0]}
            options={geoMode}
            isSearchable={false}
            onChange={(selected) => {
              setShouldCollectGeo(selected.value);
            }}
          />
          <Button 
            id="begin-button"
            onClick={startCapture}
            variant="primary"
          >
            Begin
          </Button>
        </div>
        
        <br />
        <br />
        <div className="text-box"> 
          <h3 className="trulioo-header-font">Capture Result</h3>
          <p className='trulioo-body-font'>{error}</p>
        </div>
        
        <div>
          <div className="row">
            <ImageField Title="" ImageSrc={imgResult} />
          </div>
        </div>
      </div>
    </div>  
    );
}

export default App;
