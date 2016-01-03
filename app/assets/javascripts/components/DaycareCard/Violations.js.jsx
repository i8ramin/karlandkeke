import { default as React, Component, PropTypes } from 'react';

class Violations extends Component {
  render() {
    const { infractions } = this.props;
    const count = infractions.length;
    const title = count === 1 ? '1 Violation' : `${count} violations`;
    const violationList = infractions.map((infraction) =>{
      const description = infraction.short_description ? infraction.short_description : infraction.violation_summary;
      return (
        <div className={`item infraction violation-${infraction.multiplier}`} key={infraction._id}>
          {description}
        </div>
      )
    });
    const list = count > 1 ?
      (
        <div className="ui list violation-list">
          {violationList}
        </div>
      ) : '';

    return (
      <div className="violations">
        <strong>
          {title}
          {list}
        </strong>
      </div>
    );
  }
}

Violations.propTypes = {
  infractions: PropTypes.array.isRequired,
}

export default Violations;
