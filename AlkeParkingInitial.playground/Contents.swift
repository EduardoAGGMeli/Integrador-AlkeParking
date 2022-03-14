import Foundation

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
    var parkedTime: Int { get }
}

struct Parking {
    var vehicles: Set<Vehicle> = []
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        guard vehicles.count < 20 else {
            print("No hay capacidad")
            onFinish(false)
            return
        }
        if vehicles.insert(vehicle).inserted {
            print("Se agrego el vehiculo")
            onFinish(true)
        } else {
            print("Ya existe este vehiculo")
            onFinish(false)
        }
    }

    mutating func removeVehicleToParking (vehicle: Vehicle){
        if vehicles.remove(vehicle) != nil {
            print("Se ha elimiando el vehiculo")
        } else {
            print("Ese vehiculo no esta en el parqueadero")
        }
    }
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    let discountCard: String?
    
    var parkedTime: Int {
        return Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}
enum VehicleType {
    case car
    case motorcycle
    case bus
    case miniBus
    
    var price: Int {
        switch self {
        case .car:
            return 20
        case .motorcycle:
            return 15
        case .bus:
            return 25
        case .miniBus:
            return 30
        }
    }
}

var alkeParking = Parking()

let car = Vehicle(plate: "AA111AA", type: VehicleType.car,
checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let motorcycle = Vehicle(plate: "B222BBB", type:
VehicleType.motorcycle, checkInTime: Date(), discountCard: nil)
let miniBus = Vehicle(plate: "CC333CC", type:
VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let bus = Vehicle(plate: "DD444DD", type: VehicleType.bus,
checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
alkeParking.vehicles.insert(car)
alkeParking.vehicles.insert(motorcycle)
alkeParking.vehicles.insert(miniBus)
alkeParking.vehicles.insert(bus)


alkeParking.checkInVehicle(car) { wasAdded in
    print("Sorry, the check-in failed")
}
alkeParking.removeVehicleToParking(vehicle: bus)
