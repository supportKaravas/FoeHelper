//
//  DataStructures.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import Foundation

let urlString = "http://127.0.0.1:8080/gkaravas/foeHelper/external/postman"
//let urlString = "https://192.168.1.21:8443/ageit/gshop/ext/postman"
//let urlString = "http://localhost:8080/ageit/gshop/ext/postman"
//let urlString = "https://localhost:8443/ageit/gshop/ext/postman"
//let urlString = "https://www.ageit.gr/gshop/ext/postman"

public struct Good: Codable, Identifiable{
    public var code: String
    public var id: Int

}

public struct Age: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var previous: String?
    public var next: String?
    public var goods: [Good]?
}

public struct Post: Encodable{
//    public var user: User?
    public var code: String?
}

public struct ReturnData: Codable{
    public var age: Age?
    public var ages: [Age]?
}

