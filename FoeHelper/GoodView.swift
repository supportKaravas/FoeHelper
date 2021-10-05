//
//  GoodView.swift
//  FoeHelper
//
//  Created by George Karavas on 1/10/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct GoodView: View {
//    @Binding var showGoodView: Bool
    @State var good: Good?
    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?


    var body: some View {
        ZStack{
            Form{
                HStack{
                    Text("age")
                    Spacer()
                    Text(NSLocalizedString(good!.age ?? "", comment: ""))
                }
                Section(header: Text("technologiesThatOweGood")){
                    List(good!.technologies ?? []){ technology in
                        HStack{
                            Text(NSLocalizedString(technology.code, comment: ""))
                            Spacer()
                            Text("\(technology.amount)")
                        }
                    }
                }
                HStack{
                    Text("total")
                    Spacer()
                    Text("\(good!.totalTechAmount ?? 0)")
                }
                if showActivityView { MyActivityIndicatorView() }
            }
            .navigationTitle(Text(NSLocalizedString(good!.code, comment: "")))
            .onAppear(perform: {
                loadGoodData()
            })
        }
    }

    func loadGoodData(){
        var postData = Post()
        postData.code = good!.code
        guard let encoded = try? JSONEncoder().encode(postData) else {
            debugPrint("Error while trying to encode!")
            return
        }
        
        var meta = SimpleServletMetadata()
        meta.version = 1
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "LoadGood"
        post.parametersJsonString = String(data: encoded, encoding: .ascii)
        
        RestApiService()
            .execute(rootUrl: urlString,
                     post: post,
                     startHandler: {
                     },
                     onDelay: {
                        showActivityView = true
                     },
                     onSuccessHandler: {reply in
                        if let dataJsonString = reply.dataJsonString {
                            let decoder = JSONDecoder()
                            if let serviceReply = try? decoder.decode(ReturnData.self, from: dataJsonString.data(using: .utf8)!) {
                                good = serviceReply.good!
                            }else{
                                print("error!!!!!!!!!")
                            }
                        }
                     },
                     onErrorHandler: { errorStruct in
                        debugPrint(errorStruct.localizedMessage)
                        alertMessage = errorStruct.localizedMessage
                        showAlert = true
                     },
                     onFinally: {
                        showActivityView = false
                     }
            )
    }



}

struct GoodView_Previews: PreviewProvider {
    static var previews: some View {
        GoodView()
    }
}
