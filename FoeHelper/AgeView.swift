//
//  AgeView.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct AgeView: View {
    @StateObject var sharedData = SharedData()

    @State var age: Age
    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?

    var body: some View {
        ZStack{
            Form{
                Section(header: Text("ages")){
                    HStack{
                        Text("previousAge")
                        Spacer()
                        Text(NSLocalizedString(age.previous ?? "", comment: ""))
                    }
                    HStack{
                        Text("nextAge")
                        Spacer()
                        Text(NSLocalizedString(age.next ?? "", comment: ""))
                    }
                }
                Section(header: Text("goods")){
                    List(age.goods ?? []){ good in
                        NavigationLink(
                            destination: AgeView(age: age)
                                .environmentObject(sharedData)
                            ,
                            label: {
                                Text(NSLocalizedString(good.code, comment: ""))
                            })
                    }
                }
            }
            if showActivityView { MyActivityIndicatorView() }
        }
        .onAppear(perform: {
            loadAgeData()
        })
        .navigationTitle(Text(NSLocalizedString(age.code, comment: "")))
    }
    
    func loadAgeData(){
        var postData = Post()
        postData.code = age.code
        guard let encoded = try? JSONEncoder().encode(postData) else {
            debugPrint("Error while trying to encode!")
            return
        }
        
        var meta = SimpleServletMetadata()
        meta.version = 1
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "LoadAge"
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
                                age = serviceReply.age ?? TestData.age
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

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView(age: TestData.age)
    }
}
