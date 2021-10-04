//
//  ContactUsView.swift
//  FoeHelper
//
//  Created by George Karavas on 12/7/21.
//

import SwiftUI

struct ContactUsView: View {
    @EnvironmentObject var sharedData: SharedData

    @State private var name: String = ""
    @State private var eMailAddress: String = ""
    @State private var phoneNumber: String = ""
    @State private var comments: String = ""

    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @State private var showActivity: Bool = false

    var body: some View {
        ZStack{
            Form{
                Section(header: Text(NSLocalizedString("COMMUNICATION_WAYS", comment: "Communication ways"))){
                    TextField(NSLocalizedString("NAME", comment: "name"), text: $name)
                        .multilineTextAlignment(.center)
                    TextField(NSLocalizedString("E_MAIL", comment: "e-mail"), text: $eMailAddress)
                        .multilineTextAlignment(.center)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField(NSLocalizedString("PHONE_NUMBER_MESSAGE", comment: "Phone number"), text: $phoneNumber)
                        .multilineTextAlignment(.center)
                        .keyboardType(.phonePad)
                }
                Section(header: Text(NSLocalizedString("COMMENTS", comment: "Comments"))){
                    TextEditor(text: $comments)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                }
            }
            if showActivity {
                ActivityView()
                
            }
        }
        VStack{
            Button(action: {
                showActivity = true
                doSendComments()
            }, label: {
                Text(NSLocalizedString("SEND_MESSAGE", comment: "Send"))
                    .padding()
            })
            .background(Color("ButtonColor"))
            .cornerRadius(10.0)
            .disabled(
                comments.isEmpty
            )
        }

        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text(alertTitle),
                message: Text(NSLocalizedString(alertMessage, comment: "RestApi reply")),
                dismissButton: .default(Text("OK"), action: {
                    showAlert = false
                })
            )
        })

        .navigationTitle(NSLocalizedString("CONTACT_US", comment: "Contact us"))
    }
    
    private func doSendComments() {
        let comment = GKaravasComment()
        comment.application = "FoeHelper"
        comment.mail = eMailAddress
        comment.name = name
        comment.phoneNumber = phoneNumber
        comment.textMessage = comments
        
        
        let api = RestClient()
        api.contactUs(comment: comment, sharedData: sharedData, completionHandler: { reply, error in
            if error == nil {
                if let reply = reply, let msg = reply.localizedMessage {
                    alertTitle = NSLocalizedString("INFO", comment: "Info title")
                    alertMessage = msg
                    showAlert = true
                }
            } else {
                alertTitle = NSLocalizedString("ERROR", comment: "Error title")
                alertMessage = (error?.localizedMessage)!
                showAlert = true
            }
            showActivity = false
        })
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}
