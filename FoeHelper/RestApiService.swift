//
//  File.swift
//
//
//  Created by George Karavas on 26/7/21.
//

import Foundation
import Dispatch

public struct SimpleServletPost: Codable {
    public init( data: SimpleServletPostData){
        self.data = data
    }
    public var data: SimpleServletPostData
}

public struct SimpleServletPostData: Codable{
    public init(){}
    public var metadata: SimpleServletMetadata?
    public var messageType: String?
    // Add other parameters here
    public var parametersJsonString: String?
}

// Use this struct to pass arguments like version, ...
// that can be set once for the hole application
public struct SimpleServletMetadata: Codable {
    public init(){}
    public var version: Int = 0
}

public struct ServletRepliedData: Codable{
    public init(){}
    public var localizedMessage: String?
    public var error: ErrorStruct?
    // Add other objects here
    public var dataJsonString: String?
}

public struct ErrorStruct: Codable {
    public init( localizedMessage: String ){ self.localizedMessage = localizedMessage }
    public var localizedMessage: String
}

public class RestApiService {
    let queue = DispatchQueue(label: "gr.ageit.restapi.delayQueue")
    
    func later(_ closure: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + 2) {
            closure()
        }
    }
    
    public init(){}

    func parse(json: Data) -> ServletRepliedData{
        var reply: ServletRepliedData = ServletRepliedData()
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(ServletRepliedData.self, from: json) {
            reply = jsonPetitions
        }
        return reply
    }

    public func execute(
        rootUrl: String,
        post: SimpleServletPostData,
        startHandler: @escaping () -> Void,
        onDelay: @escaping () -> Void,
        onSuccessHandler: @escaping (_ servletReply: ServletRepliedData) -> Void,
        onErrorHandler: @escaping (_ error: ErrorStruct) -> Void,
        onFinally: @escaping () -> Void
    ){
        debugPrint("URL:"+rootUrl);
        var finished = false
        startHandler()
        later({
            if(!finished){
                onDelay()
            }
        })
        guard let encoded = try? JSONEncoder().encode(post) else {
            debugPrint("Error while trying to encode!")
            let error = ErrorStruct(localizedMessage: "cannot_encode")
            finished = true
            onErrorHandler(error)
            onFinally()
            return
        }
        debugPrint("Sending "+(String(data: encoded, encoding: .ascii) ?? "nil"))
        let url = URL(string: rootUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            guard let data = data else {
                debugPrint("No data in response: \(error?.localizedDescription ?? "Unknown error").")

                DispatchQueue.main.async {
                    let error = ErrorStruct(localizedMessage: error?.localizedDescription ?? "no_data_responed")
                    finished = true
                    onErrorHandler(error)
                    onFinally()
                }


                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
//            decoder.dateDecodingStrategy = .iso8601
            debugPrint("Returned: "+(String(data: data, encoding: .ascii) ?? "nil"))

            if let serviceReply = try? decoder.decode(ServletRepliedData.self, from: data) {

                if serviceReply.error == nil{
                    DispatchQueue.main.async {
                        finished = true
                        onSuccessHandler( serviceReply )
                        onFinally()
                    }
                }else{
                    DispatchQueue.main.async {
                        let error = ErrorStruct(localizedMessage: serviceReply.error?.localizedMessage ?? "unkown_error")
                        finished = true
                        onErrorHandler(error)
                        onFinally()
                    }
                }

            } else {
                DispatchQueue.main.async {
                    let error = ErrorStruct(localizedMessage: "invalid_server_response")
                    finished = true
                    onErrorHandler(error)
                    onFinally()
                }
            }
            
        }.resume()

    }

    
}
