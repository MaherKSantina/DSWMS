//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import DSCore
import FluentMySQL
import Vapor

public struct WMSUserRow: DSModel {

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case email
    }

    public var id: Int?
    public var email: String

    public static var entity: String = "WMSUser"
}

public struct WMSUser: Content {

    enum CodingKeys: String, CodingKey {
        case id
        case email
    }

    public struct Post: Content {

        enum CodingKeys: String, CodingKey {
            case email
        }

        public var email: String
    }

    public struct Put: Content {

        enum CodingKeys: String, CodingKey {
            case id
            case email
        }

        public var id: Int
        public var email: String
    }

    public struct Delete: Content {

        enum CodingKeys: String, CodingKey {
            case id
        }

        public var id: Int

        public init(id: Int) {
            self.id = id
        }
    }

    public var id: Int
    public var email: String

    init(entity: WMSUserRow) {
        self.id = try! entity.requireID()
        self.email = entity.email
    }

    init(id: Int, email: String) {
        self.id = id
        self.email = email
    }
}

extension WMSUser: DSEntityRelated {
    public typealias EntityType = WMSUserRow
    public var entity: WMSUserRow {
        return WMSUserRow(id: id, email: email)
    }
}

extension WMSUser.Post: DSEntityRelated, DSEntityPost {
    public typealias EntityType = WMSUserRow

    public var entity: WMSUserRow {
        return WMSUserRow(id: nil, email: email)
    }
}

extension WMSUser.Put: DSEntityRelated, DSEntityPut {
    public typealias EntityType = WMSUserRow

    public var entity: WMSUserRow {
        return WMSUserRow(id: id, email: email)
    }
}
extension WMSUser.Delete: DSEntityRelated, DSEntityDelete {
    public typealias EntityType = WMSUserRow

    public var entity: WMSUserRow {
        return WMSUserRow(id: id, email: "")
    }
}

extension WMSUserRow: DSEntityControllable {
    public init(id: Int) {
        self.id = id
        self.email = ""
    }

    public typealias Public = WMSUser

    public var `public`: WMSUser {
        return WMSUser(entity: self)
    }
}

extension WMSUserRow: DSEntityQueryable {
    public static func whereString(queryString: String) -> String {
        return "email LIKE '%\(queryString)%'"
    }
}
