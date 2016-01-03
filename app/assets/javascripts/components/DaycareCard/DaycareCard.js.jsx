import { default as React, Component, PropTypes } from 'react';
import { default as Violations } from './Violations';

class BuildingCard extends Component {
  render() {
    const { daycare } = this.props;

    const currentYear = new Date().getFullYear();

    return (
      <div
        className="item daycare"
        data-lat={daycare.lat}
        data-lon={daycare.lon}
        data-center_name={daycare.center_name}
        data-grade={daycare.grade}>

        <div className="image">
          <div className={`grade grade-${daycare.grade}`}>{daycare.grade}</div>
        </div>
        <div className="content">
          <div className="header">
            <a href={`/daycare/${daycare.permalink}`}>
              {daycare.center_name}
            </a>
            <span className="show_map">
              &nbsp;
              <i className="map icon"></i>
            </span>
          </div>
          <div className="street_address">
            <small>{daycare.address}</small>
          </div>
          <div className="city_state_info">
            <small>{`${daycare.borough}, NY ${daycare.zipcode}`}</small>
          </div>
          <div className="phone_number">
            <small>{daycare.phone}</small>
          </div>
          <p className="description">
            <small>
              <span>{`EST ${currentYear - daycare.years_operating} `}</span>
              <strong>&middot;</strong>
              <span>{`${daycare.maximum_capacity} Capacity`}</span>
            </small>
          </p>
        </div>
        <Violations infractions={daycare.infractions} />
      </div>
    );
  }
}

BuildingCard.propTypes = {
  daycare: PropTypes.object.isRequired,
}

export default BuildingCard;
