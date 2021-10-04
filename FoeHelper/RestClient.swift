//
//  RestClient.swift
//  FoeHelper
//
//  Created by George Karavas on 13/7/21.
//

import Foundation
import UIKit

class GKaravasComment: Codable {
    public var application: String?
    public var name: String?
    public var mail: String?
    public var phoneNumber: String?
    public var textMessage: String?
}

class GKaravasPostData: Codable{
    public var application: String?
    public var messageType: String?
    public var version: String?
    public var communication: GKaravasComment?
}

class GKaravasErrorStruct: Codable{
    public var code: Int?
    public var localizedMessage: String?
}

class GKaravasServiceReply: Codable{
    public var localizedMessage: String?
    public var error: GKaravasErrorStruct?
//    public var responseTime: Date?
}

class RestClient {
//    let url = URL(string: "http://127.0.0.1:8080/gkaravas/api/action")!
//    let url = URL(string: "http://192.168.1.22:8080/gkaravas/api/action")!
    let urlGKaravas = URL(string: "https://www.gkaravas.com/api/action")!
    
    public func callApi(post: GKaravasPostData, sharedData: SharedData, completionHandler: @escaping ( GKaravasServiceReply?, GKaravasErrorStruct? ) -> Void) -> Void{
        post.version = "0.0.1"
        post.application = "FoeHelper"
        guard let encoded = try? JSONEncoder().encode(post) else {
            debugPrint("Error while trying to encode!")
            return
        }
        debugPrint("Sending "+(String(data: encoded, encoding: .ascii) ?? "nil"))
        
        var request = URLRequest(url: urlGKaravas)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            guard let data = data else {
                debugPrint("No data in response: \(error?.localizedDescription ?? "Unknown error").")

                DispatchQueue.main.async {
                    let errorStruct = GKaravasErrorStruct()
                    errorStruct.localizedMessage = error?.localizedDescription
                    completionHandler( nil, errorStruct )
                }


                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
//            decoder.dateDecodingStrategy = .iso8601
            debugPrint("Returned: "+(String(data: data, encoding: .ascii) ?? "nil"))

            if let serviceReply = try? decoder.decode(GKaravasServiceReply.self, from: data) {

                if error == nil{
                    DispatchQueue.main.async {
                        completionHandler( serviceReply, serviceReply.error )
                    }
                }else{
                    debugPrint("error")
                }

            } else {
                debugPrint("Invalid response from server")
            }
            
        }.resume()
    }

    public func contactUs( comment: GKaravasComment, sharedData: SharedData, completionHandler: @escaping ( GKaravasServiceReply?, GKaravasErrorStruct? ) -> Void) -> Void{
        let post = GKaravasPostData()
        post.messageType = "ContactUs"
        post.communication = comment

        callApi(post: post, sharedData: sharedData, completionHandler: completionHandler)
    }
    



}
