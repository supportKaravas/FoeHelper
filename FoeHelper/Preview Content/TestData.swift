//
//  TestData.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import Foundation

struct TestData{
    static var age: Age = {
        let url = Bundle.main.url(forResource: "Age", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: Age = try! decoder.decode(Age.self, from: data)
        return value
    }()

    static var good: Good = {
        let url = Bundle.main.url(forResource: "Good", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: Good = try! decoder.decode(Good.self, from: data)
        return value
    }()

    static var technology: Technology = {
        let url = Bundle.main.url(forResource: "Technology", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: Technology = try! decoder.decode(Technology.self, from: data)
        return value
    }()

}
