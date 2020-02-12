//
//  Invoice.swift
//  App
//
//  Created by Maher Santina on 4/28/19.
//

import Vapor
import Fluent
import FluentMySQL
import DSCore

public struct WMSWorkOrderRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case jobID
        case vehicleID
        case notes
        case date
    }

    public var id: Int?
    public var vehicleID: WMSVehicleRow.ID
    public var jobID: WMSJobRow.ID
    public var notes: String?
    public var date: Date

    public init(id: Int? = nil, jobID: WMSJobRow.ID, vehicleID: WMSVehicleRow.ID, notes: String?, date: Date) {
        self.id = id
        self.jobID = jobID
        self.vehicleID = vehicleID
        self.notes = notes
        self.date = date
    }
}

extension WMSWorkOrderRow: DSModel {
    public static var entity: String = "WMSWorkOrder"
}

extension WMSWorkOrderRow: Hashable {

    public static func == (lhs: WMSWorkOrderRow, rhs: WMSWorkOrderRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WMSWorkOrderRow: DSEntityControllable {
    public var `public`: WMSWorkOrder {
        return WMSWorkOrder(id: try! requireID(), jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
    }

    public init(id: Int) {
        self.id = id
        self.vehicleID = 0
        self.jobID = 0
        self.notes = nil
        self.date = Date()
    }

    public typealias Public = WMSWorkOrder
}

public struct WMSWorkOrder: Content, DSEntityPut {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case jobID
        case vehicleID
        case notes
        case date
    }

    public var id: Int
    public var vehicleID: WMSVehicleRow.ID
    public var jobID: WMSJobRow.ID
    public var notes: String?
    public var date: Date

    public init(id: Int, jobID: WMSJobRow.ID, vehicleID: WMSVehicleRow.ID, notes: String? = nil, date: Date) {
        self.id = id
        self.jobID = jobID
        self.vehicleID = vehicleID
        self.notes = notes
        self.date = date
    }

    public struct Post: DSEntityRelated, DSEntityPost {
        public var entity: WMSWorkOrderRow {
            return WMSWorkOrderRow(id: nil, jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
        }

        public typealias EntityType = WMSWorkOrderRow

        public var id: Int?
        public var jobID: WMSJobRow.ID
        public var vehicleID: WMSVehicleRow.ID
        public var notes: String?
        public var date: Date
    }
}

extension WMSWorkOrder: DSEntityRelated {
    public var entity: WMSWorkOrderRow {
        return WMSWorkOrderRow(id: id, jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
    }

    public typealias EntityType = WMSWorkOrderRow
}

public struct WMSWorkOrderVehicleJobUserRow: Content {

    enum CodingKeys: String, CodingKey {
        case WMSWorkOrder_id
        case WMSWorkOrder_notes
        case WMSWorkOrder_date
        case WMSVehicle_id
        case WMSVehicle_name
        case WMSVehicle_userID
        case WMSUser_id
        case WMSUser_email
        case WMSJob_id
        case WMSJob_name
    }
    public var WMSWorkOrder_id: Int
    public var WMSWorkOrder_notes: String?
    public var WMSWorkOrder_date: Date
    public var WMSVehicle_id: Int
    public var WMSVehicle_name: String
    public var WMSVehicle_userID: Int
    public var WMSUser_id: Int
    public var WMSUser_email: String
    public var WMSJob_id: Int
    public var WMSJob_name: String
}

extension WMSWorkOrderVehicleJobUserRow: Migration {
    public static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return conn.future()
    }
}

extension WMSWorkOrderVehicleJobUserRow: DSDatabaseEntityRepresentable {
    public static var entity: String {
        return tableName
    }
}

extension WMSWorkOrderVehicleJobUserRow: DSNModelView {
    public static var tables: [DSViewTable] {
        return [
            DSViewTable(name: WMSWorkOrderRow.entity, fields: WMSWorkOrderRow.CodingKeys.allCases.map{ $0.rawValue }),
            DSViewTable(name: WMSVehicleRow.entity, fields: WMSVehicleRow.CodingKeys.allCases.map{ $0.rawValue }),
            DSViewTable(name: WMSJobRow.entity, fields: WMSJobRow.CodingKeys.allCases.map{ $0.rawValue }),
            DSViewTable(name: WMSUserRow.entity, fields: WMSUserRow.CodingKeys.allCases.map{ $0.rawValue })
        ]
    }

    public static var mainTableName: String {
        return WMSWorkOrderRow.entity
    }

    public static var joins: [DSViewJoin] {
        return [
            DSViewJoin(type: .inner, foreignTable: WMSVehicleRow.entity, foreignKey: WMSVehicleRow.CodingKeys.id.rawValue, mainTable: WMSWorkOrderRow.entity, mainTableKey: WMSWorkOrderRow.CodingKeys.vehicleID.rawValue),
            DSViewJoin(type: .inner, foreignTable: WMSJobRow.entity, foreignKey: WMSJobRow.CodingKeys.id.rawValue, mainTable: WMSWorkOrderRow.entity, mainTableKey: WMSWorkOrderRow.CodingKeys.jobID.rawValue),
            DSViewJoin(type: .inner, foreignTable: WMSUserRow.entity, foreignKey: WMSUserRow.CodingKeys.id.rawValue, mainTable: WMSVehicleRow.entity, mainTableKey: WMSVehicleRow.CodingKeys.userID.rawValue)
        ]
    }
}

extension WMSWorkOrderVehicleJobUserRow: DSEntityControllable {
    public var `public`: WMSWorkOrder2 {
        let vehicle = WMSVehicle(id: WMSVehicle_id, name: WMSVehicle_name, userID: WMSVehicle_userID)
        let job = WMSJob(id: WMSJob_id, name: WMSJob_name)
        return WMSWorkOrder2(id: WMSWorkOrder_id, vehicle: vehicle, job: job, notes: WMSWorkOrder_notes, date: WMSWorkOrder_date)
    }

    public var public2: WMSWorkOrder3 {
        let user = WMSUser(id: WMSUser_id, email: WMSUser_email)
        let vehicle = WMSVehicle2(id: WMSVehicle_id, name: WMSVehicle_name, user: user)
        let job = WMSJob(id: WMSJob_id, name: WMSJob_name)
        return WMSWorkOrder3(id: WMSWorkOrder_id, vehicle: vehicle, job: job, notes: WMSWorkOrder_notes, date: WMSWorkOrder_date)
    }

    public init(id: Int) {
        self.WMSWorkOrder_id = id
        self.WMSVehicle_id = 0
        self.WMSVehicle_name = ""
        self.WMSVehicle_userID = 0
        self.WMSJob_id = 0
        self.WMSJob_name = ""
        self.WMSWorkOrder_date = Date()
        self.WMSUser_id = 0
        self.WMSUser_email = ""
    }

    public typealias Public = WMSWorkOrder2

    public var id: Int? {
        get {
            return WMSWorkOrder_id
        }
        set(newValue) {
            WMSWorkOrder_id = newValue ?? 0
        }
    }

    public static func getAll2(where: String? = nil, on: DatabaseConnectable) -> EventLoopFuture<[WMSWorkOrder3]> {
        return Self.all(where: `where`, req: on).map{ $0.map{ $0.public2 } }
    }
}

public struct WMSWorkOrder2: Content {

    enum CodingKeys: String, CodingKey {
        case id
        case vehicle
        case job
        case notes
        case date
    }

    public var id: Int
    public var vehicle: WMSVehicle
    public var job: WMSJob
    public var notes: String?
    public var date: Date

    public static func getAll(on: DatabaseConnectable) -> EventLoopFuture<[WMSWorkOrder2]> {
        return WMSWorkOrderVehicleJobUserRow.getAll(on: on)
    }

    public static func getAll2(where: String? = nil, on: DatabaseConnectable) -> EventLoopFuture<[WMSWorkOrder3]> {
        return WMSWorkOrderVehicleJobUserRow.getAll2(where: `where`, on: on)
    }
}

public struct WMSWorkOrder3: Content {

    enum CodingKeys: String, CodingKey {
        case id
        case vehicle
        case job
        case notes
        case date
    }

    public var id: Int
    public var vehicle: WMSVehicle2
    public var job: WMSJob
    public var notes: String?
    public var date: Date

    public static func getAll(where: String? = nil, on: DatabaseConnectable) -> EventLoopFuture<[WMSWorkOrder3]> {
        return WMSWorkOrder2.getAll2(where: `where`, on: on)
    }
}
