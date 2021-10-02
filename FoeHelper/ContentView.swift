//
//  ContentView.swift
//  FoeHelper
//
//  Created by George Karavas on 12/7/21.
//

import SwiftUI
import KaravasSwiftUtilsLibrary

class SharedData: ObservableObject {
    @Published var arcReturn: String = "90.0"
    @Published var contributionReturnPercent: String = "90.0"
}

struct ContentView: View {
    @StateObject var sharedData = SharedData()

    @State var showActivity: Bool = false
    
    @State var showGameDataView: Bool = false
    
    var body: some View {
        HStack{
            Image(uiImage: UIImage(named: "FoeHelperImage") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64, alignment: .center)
                .clipShape(Circle(), style: FillStyle())
            Text(NSLocalizedString("FOE_HELPER_TITLE", comment: "FOE helper"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
        ZStack{
            NavigationView{
                List{
                    NavigationLink(
                        destination: AgesView(showGameDataView: $showGameDataView)
                            .environmentObject(sharedData)
                        ,
                        label: {
                            Text(NSLocalizedString("ages", comment: ""))
                        })
                    NavigationLink(
                        destination: AttackBuildingView()
                            .environmentObject(sharedData)
                        ,
                        label: {
                            Text(NSLocalizedString("ATTACK_BUILDING", comment: "Attack building"))
                        })
                    NavigationLink(
                        destination: ContributeBuildingView()
                            .environmentObject(sharedData)
                        ,
                        label: {
                            Text(NSLocalizedString("CONTRIBUTE_BUILDING", comment: "Contribute building"))
                        })
                    NavigationLink(
                        destination: SettingsView()
                            .environmentObject(sharedData)
                        ,
                        label: {
                            Text(NSLocalizedString("SETTINGS", comment: "Settings"))
                        })
                    NavigationLink(
                        destination: ContactUsView()
                                    .environmentObject(sharedData),
                        label: {
                            Text(NSLocalizedString("CONTACT_US", comment: "Contact us"))
                        })
                }
                
                .navigationTitle(NSLocalizedString("START_MESSAGE", comment: "Start"))
                .onAppear(){
                    sharedData.arcReturn = UserDefaults.standard.string(forKey: "arcReturn") ?? "90.0"
                    sharedData.contributionReturnPercent = UserDefaults.standard.string(forKey: "contributionReturnPercent") ?? "90.0"
                }

            }
            if showActivity { MyActivityIndicatorView() }

        }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
