//
//  GreatBuildingsView.swift
//  FoeHelper
//
//  Created by George Karavas on 14/10/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct GreatBuildingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var sharedData = SharedData()
    
    @State var buildings: [DetailRow]?
    
    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?

    var body: some View {
        ZStack{
            List(buildings ?? []){ row in
                NavigationLink(
                    destination: GreatBuildingView(buildingCode: row.code)
                        .environmentObject(sharedData)
                    ,
                    label: {
                        Text(NSLocalizedString(row.code, comment: ""))
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
            loadGreatBuildingsData()
        })
        .navigationTitle(Text(NSLocalizedString("greatBuildings", comment: "")))
    }
    func loadGreatBuildingsData(){
        var meta = SimpleServletMetadata()
        meta.version = servletVersion
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "LoadGreatBuildings"

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
                                buildings = serviceReply.details ?? []
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

struct GreatBuildingsView_Previews: PreviewProvider {
    static var previews: some View {
        GreatBuildingsView(buildings: TestData.greatBuildings)
    }
}
