import Foundation

protocol Parkable {
    
    //MARK: Properties
    
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
    var parkedTime: Int { get }
}

enum ParkingState: String {
    case added = "Vehicle was added successfully"
    case parkingFull = "Parking is full"
    case alreadyExists = "Vehicle is already in the Parking"
    case deletedVehicle = "Vehicle was deleted successfully"
    
    var description: String {
        return rawValue
    }
} //ParkingState

enum ParkingError: String {
    case doesNotExist = "Vehicle is not in the Parking"
    
    var description: String {
        return rawValue
    }
} //ParkingError

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
} //VehicleType

struct Vehicle: Parkable, Hashable {
    
    //MARK: Properties
    
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    let discountCard: String?
    
    //MARK: Computed properties
    
    var parkedTime: Int { //return the parking time in minutes
        return Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    
    var hasDiscountCard: Bool {
        return discountCard != nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
} //Vehicle

struct Constants {
    
    //MARK: Stactic properties
    
    static let maxVehicles = 20
    static let twoHoursInParking = 120
    static let quarterHour = 15
    static let costFraction = 5
    static let discountValue = 0.15
}

struct Parking {
    
    //MARK: Properties
    
    var vehicles: Set<Vehicle> = []
    var totalBalanceAndVehiclesChecked: (vehiclesCheckOut:Int, earnings:Int) = (0, 0)
    
    //MARK: Methods
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (ParkingState) -> Void) {
        guard vehicles.count < Constants.maxVehicles else { //check available space
            onFinish(.parkingFull)
            return
        }
        
        if vehicles.insert(vehicle).inserted { //insert the vehicle
            onFinish(.added)
        } else {
            onFinish(.alreadyExists)
        }
    }
    
    mutating func removeVehicleToParking(vehicle: Vehicle) -> Bool{ //check if the vehicle was deleted
        return vehicles.remove(vehicle) != nil
    }
    
    mutating private func checkOut(plate: String, onSuccess: (Int) -> Void, onError: (ParkingError) -> Void) {
        //vehicles.filter { $0.plate == plate }.first
        guard let foundVehicle = vehicles.first(where: { $0.plate == plate }) else { //unwrap foundVehicle
            onError(.doesNotExist)
            return
        }
        
        let fee = calculateFee(vehicle: foundVehicle)
        removeVehicleToParking(vehicle: foundVehicle)
        totalBalanceAndVehiclesChecked.vehiclesCheckOut += 1
        totalBalanceAndVehiclesChecked.earnings += fee
        onSuccess (fee)
    }
    
    mutating func checkOutVehicle(plate: String) {
        checkOut(plate: plate,
                 onSuccess: { print("Your fee is $\($0). Come back soon") },
                 onError: { print($0.description) })
    }
    
    private func calculateFee(vehicle: Vehicle) -> Int {
        let parkedTime = vehicle.parkedTime
        var amountPayable = vehicle.type.price
        if parkedTime > Constants.twoHoursInParking {
            let numberFraction = Double(parkedTime - Constants.twoHoursInParking)/Double(Constants.quarterHour)
            amountPayable += Int(ceil(numberFraction)) * Constants.costFraction
        }
        if vehicle.hasDiscountCard {
            amountPayable = Int(Double(amountPayable) - Double(amountPayable) * Constants.discountValue)
        }
        return amountPayable
    }
    
    func printTotalBalanceAndVehiclesChecked() {
        print("\(totalBalanceAndVehiclesChecked.vehiclesCheckOut) vehicles have checked out and have earnings of $\(totalBalanceAndVehiclesChecked.earnings)")
    }
    
    func listVehiclesPlates() {
        /*for vehicle in vehicles {
            print(vehicle.plate)
        }*/
        let vehiclesPlates = vehicles.map {$0.plate}
        print(vehiclesPlates)
    }
}

var alkeParking = Parking()

//Vehicle instances
let vehicle1 = Vehicle(plate: "AA111AA", type: .car, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_001")
let vehicle2 = Vehicle(plate: "B222BBB", type: .motorcycle, checkInTime: Date(), discountCard: nil)
let vehicle3 = Vehicle(plate: "CC333CC", type: .miniBus, checkInTime: Date(), discountCard:
nil)
let vehicle4 = Vehicle(plate: "DD444DD", type: .bus, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_002")
let vehicle5 = Vehicle(plate: "AA111BB", type: .car, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_003")
let vehicle6 = Vehicle(plate: "B222CCC", type: .motorcycle, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_004")
let vehicle7 = Vehicle(plate: "CC333DD", type: .miniBus, checkInTime: Date(), discountCard:
nil)
let vehicle8 = Vehicle(plate: "DD444EE", type: .bus, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_005")
let vehicle9 = Vehicle(plate: "AA111CC", type: .car, checkInTime: Date(), discountCard: nil)
let vehicle10 = Vehicle(plate: "B222DDD", type: .motorcycle, checkInTime: Date(), discountCard: nil)
let vehicle11 = Vehicle(plate: "CC333EE", type: .miniBus, checkInTime: Date(), discountCard:
nil)
let vehicle12 = Vehicle(plate: "DD444GG", type: .bus, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_006")
let vehicle13 = Vehicle(plate: "AA111DD", type: .car, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_007")
let vehicle14 = Vehicle(plate: "B222EEE", type: .motorcycle, checkInTime: Date(), discountCard: nil)
let vehicle15 = Vehicle(plate: "CC333FF", type: .miniBus, checkInTime: Date(), discountCard: nil)
let vehicle16 = Vehicle(plate: "CC333FH", type: .miniBus, checkInTime: Date(), discountCard: nil)
let vehicle17 = Vehicle(plate: "CC333FZ", type: .miniBus, checkInTime: Date(), discountCard: nil)
let vehicle18 = Vehicle(plate: "AA111AB", type: .car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle19 = Vehicle(plate: "B222BBC", type: .motorcycle, checkInTime: Date(), discountCard: nil)
let vehicle20 = Vehicle(plate: "CC333CD", type: .miniBus, checkInTime: Date(), discountCard: nil)
let vehicle21 = Vehicle(plate: "DD444DE", type: .bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")

let arrayVehicles = [ vehicle1, vehicle2, vehicle3, vehicle4, vehicle5, vehicle6, vehicle7, vehicle8, vehicle9, vehicle10, vehicle11, vehicle12, vehicle13, vehicle14, vehicle15, vehicle16, vehicle17, vehicle18, vehicle19, vehicle20, vehicle21 ]


arrayVehicles.forEach { vehicle in
    alkeParking.checkInVehicle(vehicle) { print($0.description) }
}

/*alkeParking.checkInVehicle(vehicle1) { state in  print(state.description) } //{ print($0.description) }
alkeParking.removeVehicleToParking(vehicle: bus)*/

alkeParking.checkOutVehicle(plate: "AA111AB")
alkeParking.printTotalBalanceAndVehiclesChecked()
alkeParking.listVehiclesPlates()
