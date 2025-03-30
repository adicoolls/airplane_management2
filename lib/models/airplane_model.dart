class AirplaneModel {
    AirplaneModel({
        required this.pagination,
        required this.data,
    });

    final Pagination? pagination;
    final List<Datum> data;

    factory AirplaneModel.fromJson(Map<String, dynamic> json){ 
        return AirplaneModel(
            pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.flightDate,
        required this.flightStatus,
        required this.departure,
        required this.arrival,
        required this.airline,
        required this.flight,
        required this.aircraft,
        required this.live,
    });

    final DateTime? flightDate;
    final String? flightStatus;
    final Arrival? departure;
    final Arrival? arrival;
    final Airline? airline;
    final Flight? flight;
    final Aircraft? aircraft;
    final dynamic live;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            flightDate: DateTime.tryParse(json["flight_date"] ?? ""),
            flightStatus: json["flight_status"],
            departure: json["departure"] == null ? null : Arrival.fromJson(json["departure"]),
            arrival: json["arrival"] == null ? null : Arrival.fromJson(json["arrival"]),
            airline: json["airline"] == null ? null : Airline.fromJson(json["airline"]),
            flight: json["flight"] == null ? null : Flight.fromJson(json["flight"]),
            aircraft: json["aircraft"] == null ? null : Aircraft.fromJson(json["aircraft"]),
            live: json["live"],
        );
    }

}

class Aircraft {
    Aircraft({
        required this.registration,
        required this.iata,
        required this.icao,
        required this.icao24,
    });

    final String? registration;
    final String? iata;
    final String? icao;
    final String? icao24;

    factory Aircraft.fromJson(Map<String, dynamic> json){ 
        return Aircraft(
            registration: json["registration"],
            iata: json["iata"],
            icao: json["icao"],
            icao24: json["icao24"],
        );
    }

}

class Airline {
    Airline({
        required this.name,
        required this.iata,
        required this.icao,
    });

    final String? name;
    final String? iata;
    final String? icao;

    factory Airline.fromJson(Map<String, dynamic> json){ 
        return Airline(
            name: json["name"],
            iata: json["iata"],
            icao: json["icao"],
        );
    }

}

class Arrival {
    Arrival({
        required this.airport,
        required this.timezone,
        required this.iata,
        required this.icao,
        required this.terminal,
        required this.gate,
        required this.baggage,
        required this.delay,
        required this.scheduled,
        required this.estimated,
        required this.actual,
        required this.estimatedRunway,
        required this.actualRunway,
    });

    final String? airport;
    final String? timezone;
    final String? iata;
    final String? icao;
    final String? terminal;
    final String? gate;
    final String? baggage;
    final int? delay;
    final DateTime? scheduled;
    final DateTime? estimated;
    final dynamic actual;
    final dynamic estimatedRunway;
    final dynamic actualRunway;

    factory Arrival.fromJson(Map<String, dynamic> json){ 
        return Arrival(
            airport: json["airport"],
            timezone: json["timezone"],
            iata: json["iata"],
            icao: json["icao"],
            terminal: json["terminal"],
            gate: json["gate"],
            baggage: json["baggage"],
            delay: json["delay"],
            scheduled: DateTime.tryParse(json["scheduled"] ?? ""),
            estimated: DateTime.tryParse(json["estimated"] ?? ""),
            actual: json["actual"],
            estimatedRunway: json["estimated_runway"],
            actualRunway: json["actual_runway"],
        );
    }

}

class Flight {
    Flight({
        required this.number,
        required this.iata,
        required this.icao,
        required this.codeshared,
    });

    final String? number;
    final String? iata;
    final String? icao;
    final Codeshared? codeshared;

    factory Flight.fromJson(Map<String, dynamic> json){ 
        return Flight(
            number: json["number"],
            iata: json["iata"],
            icao: json["icao"],
            codeshared: json["codeshared"] == null ? null : Codeshared.fromJson(json["codeshared"]),
        );
    }

}

class Codeshared {
    Codeshared({
        required this.airlineName,
        required this.airlineIata,
        required this.airlineIcao,
        required this.flightNumber,
        required this.flightIata,
        required this.flightIcao,
    });

    final String? airlineName;
    final String? airlineIata;
    final String? airlineIcao;
    final String? flightNumber;
    final String? flightIata;
    final String? flightIcao;

    factory Codeshared.fromJson(Map<String, dynamic> json){ 
        return Codeshared(
            airlineName: json["airline_name"],
            airlineIata: json["airline_iata"],
            airlineIcao: json["airline_icao"],
            flightNumber: json["flight_number"],
            flightIata: json["flight_iata"],
            flightIcao: json["flight_icao"],
        );
    }

}

class Pagination {
    Pagination({
        required this.limit,
        required this.offset,
        required this.count,
        required this.total,
    });

    final int? limit;
    final int? offset;
    final int? count;
    final int? total;

    factory Pagination.fromJson(Map<String, dynamic> json){ 
        return Pagination(
            limit: json["limit"],
            offset: json["offset"],
            count: json["count"],
            total: json["total"],
        );
    }

}
