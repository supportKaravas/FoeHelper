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

    @State var age: Age?
    @State var showActivityView = false

    @State var showAlert = false
    @State var alertMessage: String?

    @State var showGoodView: Bool = false
    @State var good: Good?


    var body: some View {
        ZStack{
            Form{
                Section(header: Text("ages")){
                    HStack{
                        Text("previousAge")
                        Spacer()
                        Text(NSLocalizedString(age!.previous ?? "", comment: ""))
                    }
                    HStack{
                        Text("nextAge")
                        Spacer()
                        Text(NSLocalizedString(age!.next ?? "", comment: ""))
                    }
                }
                Section(header: Text("goods")){
                    List(age!.goods ?? []){ good in
                        NavigationLink(
                            destination: GoodView(good: good)
                                .environmentObject(sharedData)
                            ,
                            label: {
                                Text(NSLocalizedString(good.code, comment: ""))
                            })
                    }
                }
                Section(header: Text("technologies")){
                    List(age!.technologies ?? []){ technology in
                        NavigationLink(
                            destination: TechnologyView(technology: technology)
                                .environmentObject(sharedData)
                            ,
                            label: {
                                Text(NSLocalizedString(technology.code, comment: ""))
                            })
                    }
                }
                Section(header: Text("requires")){
                    List(age!.requiredGoods ?? []){ good in
                        HStack{
                            Text(NSLocalizedString(good.code, comment: ""))
                            Spacer()
                            Text("\(good.amount!)")
                        }
                    }
                }

            }
            if showActivityView { MyActivityIndicatorView() }
        }
        .onAppear(perform: {
            loadAgeData()
        })
        .navigationTitle(Text(NSLocalizedString(age!.code, comment: "")))
        .fullScreenCover(isPresented: $showGoodView, content: {
            GoodView( good: good!  )
        })
    }
    
    func loadAgeData(){
        var postData = Post()
        postData.code = age!.code
        guard let encoded = try? JSONEncoder().encode(postData) else {
            debugPrint("Error while trying to encode!")
            return
        }
        
        var meta = SimpleServletMetadata()
        meta.version = servletVersion
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
                                age = serviceReply.age!
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
//        AgeView(age: TestData.age)
        AgeView()
    }
}
