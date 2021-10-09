//
//  TechnologyView.swift
//  FoeHelper
//
//  Created by George Karavas on 6/10/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct TechnologyView: View {
    @StateObject var sharedData = SharedData()
    
    @State var technology: Technology?
    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?

    var body: some View {
        ZStack{
            Form{
                Section(header: Text("points")){
                    HStack{
                        Text("REQUIRED_POINTS")
                        Spacer()
                        Text(NSLocalizedString(String(technology!.points ?? 0) , comment: ""))
                    }
                }
                Section(header: Text("REQUIRES")){
                    List(technology!.goods ?? []){ good in
                    HStack{
                        Text(NSLocalizedString(good.code , comment: ""))
                        Spacer()
                        Text(NSLocalizedString(String(good.amount ?? "") , comment: ""))
                    }
                    }
                }
            }
            if showActivityView { MyActivityIndicatorView() }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text( "alert" ),
                message: Text(NSLocalizedString(alertMessage!, comment: "")),
                dismissButton: .default(
                                Text("ok"),
                                action: {
                                    showAlert = false
//                                    if(registeredOk){
//                                        showRegisterView = false
//                                        presentationMode.wrappedValue.dismiss()
//                                    }
                                }
                            )
                
            )
        })
        .onAppear(perform: {
            loadTechnology()
        })
        .navigationTitle(NSLocalizedString(technology!.code,comment: ""))
    }


    func loadTechnology(){
        var postData = Post()
        postData.code = technology!.code
        guard let encoded = try? JSONEncoder().encode(postData) else {
            debugPrint("Error while trying to encode!")
            return
        }
        
        var meta = SimpleServletMetadata()
        meta.version = 1
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "LoadTechnology"
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
                                technology = serviceReply.technology!
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

struct TechnologyView_Previews: PreviewProvider {
    static var previews: some View {
        TechnologyView( technology: TestData.technology)
    }
}

