//
//  GameDataView.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct AgesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var sharedData = SharedData()

    @State var ages: [Age] = []

    @Binding var showGameDataView: Bool
    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?
    
    @State var replyStr: String = "test"

    var body: some View {
        ZStack{
            List(ages){ age in
                NavigationLink(
                    destination: AgeView(age: age)
                        .environmentObject(sharedData)
                    ,
                    label: {
                        Text(NSLocalizedString(age.code, comment: ""))
                    })
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
            loadAgesData()
        })
        .navigationTitle(Text(NSLocalizedString("ages", comment: "")))
    }
    
    
    func loadAgesData(){
        var meta = SimpleServletMetadata()
        meta.version = servletVersion
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "LoadAges"

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
                                ages = serviceReply.ages ?? []
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

struct GameDataView_Previews: PreviewProvider {
    static var previews: some View {
        AgesView(showGameDataView: .constant(true))
    }
}
