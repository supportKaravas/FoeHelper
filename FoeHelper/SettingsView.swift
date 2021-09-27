//
//  SettingsView.swift
//  FoeHelper
//
//  Created by George Karavas on 12/7/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedData: SharedData

    @State private var arcReturnPercent: String = ""
    @State private var contributionReturnPercent: String = ""

    var body: some View {
        Form{
            Section(header: Text(NSLocalizedString("GAME_SETTINGS", comment: "Game settings"))){
                HStack{
                    Text(NSLocalizedString("ARC_PRC_RETURN", comment: "Arc return percent"))
                        .layoutPriority(1)
                    Spacer()
                    TextField("90.0", text: $arcReturnPercent)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack{
                    Text(NSLocalizedString("CONTRIBUTION_RETURN", comment: "Contribution return percent"))
                        .layoutPriority(1)
                    Spacer()
                    TextField("90.0", text: $contributionReturnPercent)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
            }
        }
        VStack{
            Button(action: {
                sharedData.arcReturn = arcReturnPercent
                sharedData.contributionReturnPercent = contributionReturnPercent
                UserDefaults.standard.setValue(arcReturnPercent, forKey: "arcReturn")
                UserDefaults.standard.setValue(contributionReturnPercent, forKey: "contributionReturnPercent")
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(NSLocalizedString("SAVE_MESSAGE", comment: "Save"))
                    .padding()
            })
            .background(Color("ButtonColor"))
            .cornerRadius(10.0)
            .disabled(
                arcReturnPercent.isEmpty || contributionReturnPercent.isEmpty
            )
        }
        .navigationTitle(NSLocalizedString("SETTINGS", comment: "Settings"))
        
        .onAppear(){
            arcReturnPercent = sharedData.arcReturn
            contributionReturnPercent = sharedData.contributionReturnPercent
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SharedData())
    }
}
