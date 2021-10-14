//
//  GreatBuildingLevelView.swift
//  FoeHelper
//
//  Created by George Karavas on 14/10/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

struct GreatBuildingLevelView: View {
    @State var level: GreatBuildingLevel?

    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?

    var body: some View {
        ZStack{
            Form{
                Section(){
                    HStack{
                        Text("points")
                        Spacer()
                        Text("\(level?.points ?? 0)")
                    }
                    HStack{
                        Text("owner")
                        Spacer()
                        Text("\(level?.ownerPoints ?? 0)")
                    }

                }

                Section(header: Text("position \(1)")){
                    HStack{
                        Text("owner")
                        Spacer()
                        Text("\(level?.ownerPoints1 ?? 0)")
                    }
                    HStack{
                        Text("arcHelp")
                        Spacer()
                        Text("\(level?.arcPoints1 ?? 0)")
                    }
                }

                Section(header: Text("position \(2)")){
                    HStack{
                        Text("owner")
                        Spacer()
                        Text("\(level?.ownerPoints2 ?? 0)")
                    }
                    HStack{
                        Text("arcHelp")
                        Spacer()
                        Text("\(level?.arcPoints2 ?? 0)")
                    }
                }
                
                Section(header: Text("position \(3)")){
                    HStack{
                        Text("owner")
                        Spacer()
                        Text("\(level?.ownerPoints3 ?? 0)")
                    }
                    HStack{
                        Text("arcHelp")
                        Spacer()
                        Text("\(level?.arcPoints3 ?? 0)")
                    }
                }
                
                Section(header: Text("position \(4)")){
                    HStack{
                        Text("owner")
                        Spacer()
                        Text("\(level?.ownerPoints4 ?? 0)")
                    }
                    HStack{
                        Text("arcHelp")
                        Spacer()
                        Text("\(level?.arcPoints4 ?? 0)")
                    }
                }
                
                Section(header: Text("position \(5)")){
                    HStack{
                        Text("owner")
                        Spacer()
                        Text("\(level?.ownerPoints5 ?? 0)")
                    }
                    HStack{
                        Text("arcHelp")
                        Spacer()
                        Text("\(level?.arcPoints5 ?? 0)")
                    }
                }

                /*
                Section(header: Text("requires")){
                    List(building?.requiredGoods ?? []){ good in
                        HStack{
                            Text(NSLocalizedString(good.code, comment: ""))
                            Spacer()
                            Text("\(good.amount!)")
                        }
                    }
                }
*/

            }
            if showActivityView { MyActivityIndicatorView() }
        }
        .onAppear(perform: {
            loadData()
        })
        .navigationTitle(Text("lvl \(level?.aa ?? 0)"))
    }
    
    func loadData(){
        var postData = Post()
        postData.id = level?.id
        postData.arcPercent = 90.0
        guard let encoded = try? JSONEncoder().encode(postData) else {
            debugPrint("Error while trying to encode!")
            return
        }
        
        var meta = SimpleServletMetadata()
        meta.version = 1
        var post = SimpleServletPostData()
        post.metadata = meta
        post.messageType = "CalculateLevel"
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
                                level = serviceReply.level!
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

struct GreatBuildingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        GreatBuildingLevelView(level: TestData.greatBuildingLevel)
    }
}
