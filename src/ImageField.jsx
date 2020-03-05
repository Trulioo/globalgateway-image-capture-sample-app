import React from 'react';
import PropTypes from 'prop-types';
import './css/image-feild.css';

export default function ImageSummary({
  Title, ImageSrc,
}) {
  return (
    <div id="image-field-container">
      <h5 id="image-field-title" className="trulioo-input-font form-label">{Title}</h5>
      <div id="image-field-img-container">
        {ImageSrc !== null ? <img
          id="image-field-img"
          alt="Img Field"
          src={ImageSrc}
        /> : 
        null}
      </div>
    </div>
  );
}

ImageSummary.propTypes = {
  Title: PropTypes.string.isRequired,
  ImageSrc: PropTypes.string.isRequired
};

