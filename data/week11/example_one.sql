CREATE TABLE example_one
(
  call_number integer NOT NULL,
  unit_id character varying(5) NOT NULL,
  incident_number integer NOT NULL,
  call_type character varying(27) NOT NULL,
  call_date date NOT NULL,
  watch_date date NOT NULL,
  received_dttm timestamp without time zone NOT NULL,
  entry_dttm timestamp without time zone NOT NULL,
  dispatch_dttm timestamp without time zone NOT NULL,
  response_dttm timestamp without time zone,
  on_scene_dttm timestamp without time zone,
  transport_dttm timestamp without time zone,
  hospital_dttm timestamp without time zone,
  call_final_disposition character varying(26) NOT NULL,
  available_dttm timestamp without time zone NOT NULL,
  address character varying(30) NOT NULL,
  city character varying(13) NOT NULL,
  zipcode_of_incident integer NOT NULL,
  battalion character varying(3) NOT NULL,
  station_area integer NOT NULL,
  box integer NOT NULL,
  original_priority character varying(1) NOT NULL,
  priority character varying(1) NOT NULL,
  final_priority integer NOT NULL,
  als_unit boolean NOT NULL,
  call_type_group character varying(28) NOT NULL,
  number_of_alarms integer NOT NULL,
  unit_type character varying(14) NOT NULL,
  unit_sequence_in_call_dispatch integer NOT NULL,
  fire_prevention_district integer NOT NULL,
  supervisor_district integer NOT NULL,
  neighborhooods character varying(30) NOT NULL,
  location character varying(37) NOT NULL,
  rowid character varying(15) NOT NULL
);
