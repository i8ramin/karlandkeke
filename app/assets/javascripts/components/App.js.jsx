import { default as React } from 'react';
import { default as ReactDOM } from 'react-dom';
import { default as DaycareCard } from './DaycareCard/DaycareCard.js.jsx';

const daycare = {
  type: "Child Care - Pre School",
  center_name: "123 STEP AHEAD",
  permalink: "123-step-ahead",
  permit_holder: "DENIZKO DAY CARE INC",
  lat: '40.734855797607',
  lon: '-73.896014464153',
  address: "51-07 69 STREET",
  borough: "QUEENS",
  zipcode: "11377",
  phone: "718-426-0123",
  permit_status: " Permitted ",
  permit_number: "10777",
  permit_expiration_date: " 01/09/2016",
  age_range: "2 - 5",
  maximum_capacity: '27',
  site_type: "Private",
  certified_to_administer_medication: false,
  years_operating: '3',
  has_inspections: true,
  grade: "d",

  infractions: [
    {
      _id: '568847163ce8477174000009',
      violation_summary: "Child care service failed to arrange/conduct criminal/SCR background clearance checks for required individuals failed to re-clear required individuals with the SCR every two years",
      category: "Criminal justice and child abuse screening of current and prospective personnel; reports to the Department.",
      code_subsection: "4719 c",
      status: "CORRECTED",
      short_description: "Failure to arrange/conduct proper screening for required individuals or failed to re-clear required individuals every two years",
      multiplier: 2,
      extra_notes: null,
    },
    {
      _id: '568847163ce847717400000b',
      violation_summary: "At time of inspection it was determined that child care service failed to ensure staff received required training within time frames and/or failed to maintain training records",
      category: "Training.",
      code_subsection: "4737 b1",
      status: "CORRECTED",
      short_description: "Failure to ensure staff received required training within time frames and/or failed to maintain training records",
      multiplier: 2,
      extra_notes: null,
    }
  ]
}

ReactDOM.render(
  <DaycareCard daycare={daycare}/>,
  document.getElementById('react')
);
