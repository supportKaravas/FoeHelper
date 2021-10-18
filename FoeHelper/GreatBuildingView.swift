//
//  GreatBuildingView.swift
//  FoeHelper
//
//  Created by George Karavas on 14/10/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct GreatBuildingView: View {
    
    @State var buildingCode: String
    @State var building: GreatBuilding?

    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?

    var body: some View {
        ZStack{
            Form{
                Section(){
                    HStack{
                        Text("age")
                        Spacer()
                        Text(NSLocalizedString(building?.age ?? "", comment: ""))
                    }

                    HStack{
                        Text("width")
                        Spacer()
                        Text("\(building?.width ?? 0)")
                    }

                    HStack{
                        Text("height")
                        Spacer()
                        Text("\(building?.height ?? 0)")
                    }
                }
                Section(header: Text("requires")){
                    List(building?.requiredGoods ?? []){ good in
                        HStack{
                            Text(NSLocalizedString(good.code, comment: ""))
                            Spacer()
                            Text("\(good.amount!)")
                        }
                    }
                }

                Section(header: Text("levels")){
                    List(building?.levels ?? []){ record in
                        NavigationLink(
                            destination: GreatBuildingLevelView(level: record),
                            label: {
                                Text("lvl \(record.aa)")
                            })
                    }
                }

            }
            if showActivityView { MyActivityIndicatorView() }
        }
        .onAppear(perform: {
            loadData()
        })
        .navigationTitle(Text(NSLocalizedString(buildingCode, comment: "")))
    }
    
    func loadData(){
        var postData = Post()
        postData.code = buildingCode
        guard let encoded = try? JSONEncoder().encode(postData) else {
            debugPrint("Error while trying to encode!")
            return
        }
        
        var meta = SimpleServletMetadata()
        meta.version = servletVersion
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "LoadGreatBuilding"
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
                                building = serviceReply.greatBuilding!
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

struct GreatBuildingView_Previews: PreviewProvider {
    static var previews: some View {
        GreatBuildingView(buildingCode: TestData.greatBuilding.code, building: TestData.greatBuilding)
    }
}
